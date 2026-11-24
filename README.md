# Forma

App web de bolso para treino em casa, dieta e marmitas de duas pessoas. Um único arquivo (`index.html`), sem build e sem dependências.

- Dados ficam no navegador de cada aparelho.
- Sincronização opcional entre aparelhos, sem usuário e senha: um código secreto gera a chave de criptografia (AES-GCM) no aparelho. O banco só guarda texto cifrado.
- Fontes online gratuitas e sem chave: Open-Meteo, Open Food Facts, USDA FoodData Central (chave de demonstração) e TheMealDB.

## Banco (Supabase)

1. Crie um projeto em supabase.com.
2. Rode `supabase/setup.sql` no SQL Editor.
3. Preencha `SYNC_URL` e `SYNC_KEY` no topo do bloco de sincronização de `index.html` (a chave pública do projeto).

Este repositório não contém dados pessoais.
