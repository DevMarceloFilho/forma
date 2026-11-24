-- Forma: banco de dados mínimo para sincronizar os dados do casal.
-- Cole no SQL Editor do Supabase e execute uma vez.
-- Os dados chegam já criptografados no aparelho; o banco só guarda texto cifrado.
-- A tabela não é acessível diretamente: só pelas duas funções abaixo, que exigem o identificador secreto da linha.

create table if not exists public.forma_cofres (
  id          text primary key,
  payload     text not null,
  version     bigint not null default 1,
  updated_at  timestamptz not null default now()
);

alter table public.forma_cofres enable row level security;
revoke all on table public.forma_cofres from anon, authenticated;

create or replace function public.forma_get(p_id text)
returns table(payload text, version bigint)
language sql
security definer
set search_path = public
as $$
  select c.payload, c.version from public.forma_cofres c where c.id = p_id
$$;

create or replace function public.forma_put(p_id text, p_payload text, p_expected bigint)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare v bigint;
begin
  if length(p_id) <> 64 or length(p_payload) > 1500000 then
    raise exception 'invalid';
  end if;
  insert into public.forma_cofres as c (id, payload, version)
  values (p_id, p_payload, 1)
  on conflict (id) do update
    set payload = excluded.payload, version = c.version + 1, updated_at = now()
    where c.version = p_expected
  returning c.version into v;
  if v is null then
    raise exception 'conflict';
  end if;
  return v;
end
$$;

revoke all on function public.forma_get(text) from public;
revoke all on function public.forma_put(text, text, bigint) from public;
grant execute on function public.forma_get(text) to anon, authenticated;
grant execute on function public.forma_put(text, text, bigint) to anon, authenticated;
