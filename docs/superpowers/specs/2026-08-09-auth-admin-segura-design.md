# Design: Auth admin segura + RLS restrito ao admin

Data: 2026-08-09
Status: Aprovado

## Contexto e problema

O painel admin do site Route 364 (Vue 3 + Vite SPA, backend InsForge) possui três falhas de segurança:

1. **Crítico**: o arquivo `.env` usa a **API_KEY de admin** (`ik_ea6ee750c0cda41651202a89daf4e01f`) como se fosse a anon key (`VITE_SUPABASE_ANON_KEY`). Como variáveis `VITE_` são embutidas no bundle, qualquer pessoa que leia o JS do site obtém acesso admin total ao banco. A anon key pública real do backend é `anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced`.
2. O "login" admin compara email/senha hardcoded em `src/constants.ts` (`admin@route364.com` / `admin123`), embutidos no bundle, e grava apenas um flag em `sessionStorage` — não há autenticação real.
3. As políticas RLS de escrita exigem `auth.role() = 'authenticated'`, mas a app sempre envia a chave anônima, então ou as escritas estão abertas (com a API_KEY atual) ou o painel quebraria se trocada pela anon key correta.

## Decisões

- **Usuário admin**: email real do dono (`portoinforsistem@gmail.com`), criado no backend via sign-up (signups habilitados, `requireEmailVerification = false`). Senha forte gerada e mostrada uma única vez.
- **Restrição no RLS**: escrita só para `auth.email() = 'portoinforsistem@gmail.com'`. Leituras permanecem públicas (site é público).
- **SDK**: usar `@insforge/sdk` para auth (já instalado, v1.2.5).
- **Sem role/metadata**: desnecessário para um único admin (YAGNI).

## Arquitetura

### A. Credenciais no `.env`

- Trocar `VITE_SUPABASE_ANON_KEY` para a anon key pública real (`anon_c55c...`).
- A `API_KEY` de admin não aparece em nenhuma variável `VITE_*` do frontend. Ela só é usada no servidor (edge functions via `Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")` / secrets do backend).

### B. Auth real via InsForge

- Criar usuário admin no backend via endpoint de sign-up (email + senha).
- Novo composable `src/composables/useAuth.ts`:
  - Estado reativo: `user`, `loading`.
  - `signIn(email, password)` → `insforge.auth.signInWithPassword`.
  - `signOut()` → `insforge.auth.signOut` + limpeza local.
  - `getAccessToken()` → `insforge.auth.getAccessToken()` para as escritas.
  - `hydrate()` → `insforge.auth.getCurrentUser()` no boot para restaurar sessão em recarga (SDK usa refresh cookie httpOnly).
- `src/components/admin/Login.vue`: substituir a comparação hardcoded por `signIn()`. Em erro, exibir mensagem.
- Router guard (`src/router/index.ts`): usar o estado do `useAuth` em vez do flag `sessionStorage`. Se `requiresAuth` e não autenticado → `/admin`.
- `Dashboard.vue`: adicionar botão "Sair".
- `AdminLayout.vue`: verificar onde fica o logout (criar se não existir).

### C. Escritas autenticadas

- `src/api/contentApi.ts`:
  - **Leituras** (GET): manter cabeçalhos com a anon key.
  - **Escritas** (POST/PATCH/DELETE) e uploads de storage: usar `Authorization: Bearer <accessToken>` do `useAuth`.
  - Guarda por escrito: se não houver token, lançar erro e o componente redireciona ao login.

### D. RLS restrito ao admin

- Migração que substitui `auth.role() = 'authenticated'` por `auth.email() = 'portoinforsistem@gmail.com'` nas políticas de INSERT/UPDATE/DELETE das tabelas: `courses`, `testimonials`, `features`, `about_data`, `contact_info`, `footer_config`, `financial_solutions`.
- Mesma troca nas políticas de storage (buckets `courses` e `testimonials`) para INSERT/UPDATE/DELETE.
- Políticas de SELECT público permanecem `USING (true)`.
- Verificar e corrigir permissões (`GRANT`) se necessário.

### E. Limpeza

- Remover `ADMIN_EMAIL` e `ADMIN_PASSWORD` de `src/constants.ts`.

### F. Verificação

- `npm run build` sem erros.
- Conferir que o bundle não contém `ik_ea6ee750...` (API_KEY) nem `admin123`.
- Teste manual:
  - Sem login, uma escrita com a anon key deve ser negada pelo RLS.
  - Com login do admin, escritas e uploads funcionam.
  - Recarregar `/admin/dashboard` mantém a sessão.
  - "Sair" encerra a sessão e o guard redireciona.

## Arquivos afetados

- `.env` (anon key correta)
- `.env.example`
- `src/constants.ts` (remover credenciais admin)
- `src/composables/useAuth.ts` (novo)
- `src/components/admin/Login.vue`
- `src/components/admin/Dashboard.vue` / `AdminLayout.vue` (logout)
- `src/router/index.ts` (guard real)
- `src/api/contentApi.ts` (escritas com JWT)
- Migração SQL no backend (RLS admin)

## Fluxo de dados

1. Usuário abre `/admin` e digita email/senha.
2. `useAuth.signIn()` chama `insforge.auth.signInWithPassword`; SDK salva sessão (access token em memória + refresh cookie httpOnly).
3. Guard libera `/admin/dashboard`.
4. `contentApi` nas escritas pega o access token via `useAuth.getAccessToken()` e envia como `Authorization: Bearer`.
5. Backend valida o JWT; políticas RLS checam `auth.email()`; se for o admin, permite.

## Fora de escopo

- Trocar o serviço de hosting (Cloudflare Pages segue separado).
- Autenticação via OAuth (Google/GitHub) no painel.
- Múltiplos admins / papéis.
