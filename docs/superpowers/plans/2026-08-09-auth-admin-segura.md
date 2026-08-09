# Auth Admin Segura + RLS Restrito ao Admin — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eliminar a exposição da API_KEY de admin no bundle, implementar login real via InsForge Auth e restringir escritas do banco/storage ao email do admin via RLS.

**Architecture:** SPA Vue 3 + Vite fala com o backend InsForge (`https://iecvn333.us-east.insforge.app`) via `@insforge/sdk` para auth e REST para dados. Login passa a usar `insforge.auth.signInWithPassword`; o access token do usuário é enviado nas escritas (POST/PATCH/DELETE e uploads) via `Authorization: Bearer <jwt>`. As políticas RLS das 7 tabelas e dos buckets de storage passam a exigir `auth.email() = 'portoinforsistem@gmail.com'`. Leituras permanecem públicas.

**Tech Stack:** Vue 3, Vite 8, TypeScript, `@insforge/sdk` v1.2.5, PostgREST, InsForge CLI (`npx @insforge/cli` v0.1.58).

## Global Constraints

- **Nunca** colocar a API_KEY de admin (`ik_ea6ee750c0cda41651202a89daf4e01f`) em variável `VITE_*` nem em código de frontend. Ela só existe no servidor (edge functions / secrets).
- Anon key pública real do backend: `anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced`.
- Email do admin (identidade do RLS): `portoinforsistem@gmail.com`.
- Tailwind CSS **3.4** — não atualizar para v4 (`package.json` já trava `^3.4.19`).
- Uso do SDK: `@insforge/sdk` para auth. Nenhum método retorna `data,error` — sempre tratar `error`.
- CLI sempre via `npx @insforge/cli <command>`.
- Projeto já está vinculado (`.insforge/project.json`) ao projeto route364 e autenticado.

---

### Task 1: Trocar `.env` para a anon key pública

**Files:**
- Modify: `.env`
- Modify: `.env.example`

**Interfaces:**
- Produces: `VITE_SUPABASE_ANON_KEY` = `anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced` (usado pelo resto do plano).

- [ ] **Step 1: Editar `.env`**

Conteúdo final:
```bash
# InsForge Configuration
VITE_SUPABASE_URL=https://iecvn333.us-east.insforge.app
VITE_SUPABASE_ANON_KEY=anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced
```

- [ ] **Step 2: Editar `.env.example`** (sem segredo)

```bash
# InsForge Configuration
VITE_SUPABASE_URL=https://your-app.region.insforge.app
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

- [ ] **Step 3: Verificar que a API_KEY de admin saiu do bundle**

```bash
npm run build
grep -c "ik_ea6ee750c0cda41651202a89daf4e01f" dist/assets/*.js || echo "OK: admin key ausente"
grep -c "anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" dist/assets/*.js || echo "OK: anon key ausente do JS (so aparece nos fetch em runtime)"
```

Esperado: build sem erro; admin key com contagem `0`; anon key pode aparecer (é pública e legítima — usada como `apikey`).

- [ ] **Step 4: Commit** (se o repo tiver git; hoje não é repo git — registrar no memory quando aplicável)

---

### Task 2: Criar o client do SDK InsForge

**Files:**
- Modify: `src/lib/supabase.ts`

**Interfaces:**
- Produces: export `insforge` (instância de `createClient`) com `.auth` — usado por `useAuth.ts` e pelo resto.

- [ ] **Step 1: Adicionar import e instância ao topo de `src/lib/supabase.ts`**

```ts
import { createClient } from '@insforge/sdk';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase credentials not configured. Please add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY to your .env file.');
}

export const insforgeBaseUrl = supabaseUrl || '';
export const insforgeApiKey = supabaseAnonKey || '';

export const insforge = createClient({
  baseUrl: supabaseUrl || '',
  anonKey: supabaseAnonKey || '',
});
```

- [ ] **Step 2: Verificar build**

Run: `npm run build`
Expected: PASS (sem erros de tipo/import).

---

### Task 3: Criar o composable `useAuth`

**Files:**
- Create: `src/composables/useAuth.ts`

**Interfaces:**
- Consumes: `insforge` de `src/lib/supabase.ts` (Task 2).
- Produces:
  - `useAuth()` → `{ user: Ref<UserSchema|null>, loading: Ref<boolean>, ensureHydrated(): Promise<void>, signIn(email, password): Promise<void>, signOut(): Promise<void>, getAccessToken(): string|null }`

- [ ] **Step 1: Criar `src/composables/useAuth.ts`**

```ts
import { ref, type Ref } from 'vue';
import { insforge } from '../lib/supabase';

const user = ref(null) as Ref<any | null>;
const loading = ref(true);

let hydratePromise: Promise<void> | null = null;

async function hydrate() {
  loading.value = true;
  try {
    const { data, error } = await insforge.auth.getCurrentUser();
    user.value = error ? null : (data?.user ?? null);
  } catch {
    user.value = null;
  } finally {
    loading.value = false;
  }
}

function ensureHydrated() {
  if (!hydratePromise) {
    hydratePromise = hydrate();
  }
  return hydratePromise;
}

async function signIn(email: string, password: string) {
  const { data, error } = await insforge.auth.signInWithPassword({ email, password });
  if (error) throw new Error(error.message || 'Falha no login');
  user.value = data?.user ?? null;
}

async function signOut() {
  await insforge.auth.signOut();
  user.value = null;
}

function getAccessToken(): string | null {
  return insforge.auth.getAccessToken();
}

export function useAuth() {
  return { user, loading, ensureHydrated, signIn, signOut, getAccessToken };
}
```

Nota: `user` tipado como `any | null` por enquanto (evita importar `UserSchema` que pode não estar exportado). Melhorar se `npm run build` reclamar.

- [ ] **Step 2: Verificar build**

Run: `npm run build`
Expected: PASS.

---

### Task 4: Hidratar sessão no boot da app

**Files:**
- Modify: `src/main.ts`

**Interfaces:**
- Consumes: `useAuth().ensureHydrated` (Task 3).
- Produces: sessão restaurada no primeiro load (recarga de `/admin/dashboard` mantém login).

- [ ] **Step 1: Chamar `ensureHydrated` no boot**

```ts
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import { useAuth } from './composables/useAuth'

useAuth().ensureHydrated()

const app = createApp(App)
app.use(router)
app.mount('#app')
```

- [ ] **Step 2: Verificar build**

Run: `npm run build`
Expected: PASS.

---

### Task 5: Login real em `Login.vue`

**Files:**
- Modify: `src/components/admin/Login.vue`

**Interfaces:**
- Consumes: `useAuth().signIn` (Task 3).
- Produces: login que valida no backend e navega para `/admin/dashboard`.

- [ ] **Step 1: Substituir o `<script setup>` de `Login.vue`**

Substitua o bloco `script setup` (linhas 57-85 atuais) por:

```ts
<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { Lock, AlertCircle } from 'lucide-vue-next';
import { useAuth } from '../../composables/useAuth';

const router = useRouter();
const { signIn } = useAuth();

const email = ref('');
const password = ref('');
const error = ref('');
const isLoading = ref(false);

const handleLogin = async () => {
  error.value = '';
  isLoading.value = true;
  try {
    await signIn(email.value, password.value);
    router.push('/admin/dashboard');
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'E-mail ou senha incorretos.';
  } finally {
    isLoading.value = false;
  }
};
</script>
```

(Remova o import de `ADMIN_EMAIL`/`ADMIN_PASSWORD`.)

- [ ] **Step 2: Verificar build**

Run: `npm run build`
Expected: PASS.

---

### Task 6: Guard real + logout no layout admin

**Files:**
- Modify: `src/router/index.ts`
- Modify: `src/components/admin/AdminLayout.vue`

**Interfaces:**
- Consumes: `useAuth().user`, `useAuth().ensureHydrated`, `useAuth().signOut` (Task 3).
- Produces: guard assíncrono que bloqueia rotas `requiresAuth` sem usuário logado; logout limpa a sessão real.

- [ ] **Step 1: Substituir o conteúdo de `src/router/index.ts` a partir do `createRouter`**

Troque o guard atual (linhas 56-67) por:

```ts
import { createRouter, createWebHistory } from 'vue-router';
import LandingPage from '../views/LandingPage.vue';
import Login from '../components/admin/Login.vue';
import Dashboard from '../components/admin/Dashboard.vue';
import CourseManager from '../components/admin/CourseManager.vue';
import TestimonialManager from '../components/admin/TestimonialManager.vue';
import AboutManager from '../components/admin/AboutManager.vue';
import ContactManager from '../components/admin/ContactManager.vue';
import { useAuth } from '../composables/useAuth';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: LandingPage },
    { path: '/admin', name: 'admin-login', component: Login },
    { path: '/admin/dashboard', name: 'admin-dashboard', component: Dashboard, meta: { requiresAuth: true } },
    { path: '/admin/courses', name: 'admin-courses', component: CourseManager, meta: { requiresAuth: true } },
    { path: '/admin/testimonials', name: 'admin-testimonials', component: TestimonialManager, meta: { requiresAuth: true } },
    { path: '/admin/about', name: 'admin-about', component: AboutManager, meta: { requiresAuth: true } },
    { path: '/admin/contact', name: 'admin-contact', component: ContactManager, meta: { requiresAuth: true } },
  ]
});

router.beforeEach(async (to, _from, next) => {
  const { user, ensureHydrated } = useAuth();
  await ensureHydrated();
  const isAuthenticated = !!user.value;

  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/admin');
  } else if (to.path === '/admin' && isAuthenticated) {
    next('/admin/dashboard');
  } else {
    next();
  }
});

export default router;
```

- [ ] **Step 2: Atualizar o logout em `src/components/admin/AdminLayout.vue`**

Troque o `script setup` (linhas 56-74) por:

```ts
<script setup lang="ts">
import { useRouter } from 'vue-router';
import { LayoutDashboard, BookOpen, Users, LogOut, Home, Info, MessageSquare } from 'lucide-vue-next';
import { useAuth } from '../../composables/useAuth';

const router = useRouter();
const { signOut } = useAuth();

const navItems = [
  { icon: LayoutDashboard, label: 'Dashboard', path: '/admin/dashboard' },
  { icon: BookOpen, label: 'Gerenciar Cursos', path: '/admin/courses' },
  { icon: Users, label: 'Depoimentos', path: '/admin/testimonials' },
  { icon: Info, label: 'Sobre Nós', path: '/admin/about' },
  { icon: MessageSquare, label: 'Contato', path: '/admin/contact' },
];

const handleLogout = async () => {
  await signOut();
  router.push('/');
};
</script>
```

- [ ] **Step 3: Verificar build**

Run: `npm run build`
Expected: PASS.

---

### Task 7: Escritas com JWT em `contentApi.ts`

**Files:**
- Modify: `src/api/contentApi.ts`

**Interfaces:**
- Consumes: `useAuth().getAccessToken` (Task 3); `insforgeBaseUrl`, `insforgeApiKey` (existentes).
- Produces: `contentApi` com leituras públicas e escritas autenticadas (POST/PATCH/DELETE + uploads).

- [ ] **Step 1: Adicionar import e helpers de cabeçalho autenticado**

No topo de `src/api/contentApi.ts`, após o import existente:

```ts
import { useAuth } from '../composables/useAuth';
```

Depois do bloco `authHeaders` (após linha 11), adicione:

```ts
function writeHeaders() {
  const token = useAuth().getAccessToken();
  if (!token) {
    throw new Error('Sessão expirada. Faça login novamente.');
  }
  return {
    'Authorization': `Bearer ${token}`,
    'apikey': apiKey,
    'Content-Type': 'application/json'
  };
}

function writeUploadHeaders() {
  const token = useAuth().getAccessToken();
  if (!token) {
    throw new Error('Sessão expirada. Faça login novamente.');
  }
  return {
    'Authorization': `Bearer ${token}`,
    'apikey': apiKey
  };
}
```

- [ ] **Step 2: Adicionar parâmetro `authenticated` ao `fetchApi`**

Substitua a assinatura e o merge de headers (linhas 13-17):

```ts
async function fetchApi(endpoint: string, options: RequestInit = {}, authenticated = false) {
  const headers = authenticated ? writeHeaders() : authHeaders;
  const response = await fetch(`${apiUrl}${endpoint}`, {
    ...options,
    headers: { ...headers, ...options.headers }
  });
```

- [ ] **Step 3: Marcar todas as escritas com `true`**

Em cada chamada de escrita de `contentApi`, adicione `true` como terceiro argumento de `fetchApi`:

- `addCourse` → `fetchApi('/api/database/records/courses', { method: 'POST', ... }, true)`
- `updateCourse` → `fetchApi(\`/api/database/records/courses?id=eq.${course.id}\`, { method: 'PATCH', ... }, true)`
- `deleteCourse` → `fetchApi(\`/api/database/records/courses?id=eq.${id}\`, { method: 'DELETE' }, true)`
- `addTestimonial`, `updateTestimonial`, `deleteTestimonial` → idem com `testimonials`
- `updateFeature` → idem com `features`
- `updateAboutData` → idem com `about_data`
- `updateContactInfo` → idem com `contact_info`
- `updateFooterConfig` → idem com `footer_config`
- `addFinancialSolution`, `updateFinancialSolution`, `deleteFinancialSolution` → idem com `financial_solutions`

- [ ] **Step 4: Trocar os cabeçalhos dos uploads**

Nas funções `uploadTestimonialAvatar` e `uploadCourseImage` (linhas 106-148), troque os headers `'Authorization': \`Bearer ${apiKey}\`` por `writeUploadHeaders()`:

```ts
async function uploadTestimonialAvatar(file: File): Promise<string> {
  const formData = new FormData();
  formData.append('file', file);

  const response = await fetch(`${apiUrl}/api/storage/buckets/testimonials/objects`, {
    method: 'POST',
    headers: writeUploadHeaders(),
    body: formData
  });
  // ...resto igual
}
```

Idem para `uploadCourseImage` com bucket `courses`.

- [ ] **Step 5: Verificar build**

Run: `npm run build`
Expected: PASS.

---

### Task 8: Backend — criar usuário admin

**Files:**
- None (operação no backend).

**Interfaces:**
- Consumes: anon key pública; endpoint `POST {base}/api/auth/users`.
- Produces: usuário `portoinforsistem@gmail.com` ativo no InsForge Auth (usado no Task 9 como identidade do RLS e no Task 10 para testes).

- [ ] **Step 1: Gerar senha forte**

```bash
openssl rand -base64 18 | tr '+/' 'Xx'
```

Guarde o valor — é mostrado ao usuário uma única vez no final.

- [ ] **Step 2: Criar o usuário via sign-up (signups habilitados, sem verificação de email)**

```bash
curl -s -X POST "https://iecvn333.us-east.insforge.app/api/auth/users" \
  -H "Authorization: Bearer anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "apikey: anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "Content-Type: application/json" \
  -d '{"email":"portoinforsistem@gmail.com","password":"<SENHA_GERADA>"}'
```

Esperado: resposta JSON com `user` (status 200/201). Se retornar erro de "already registered", o usuário já existe — pular para o Task 9.

- [ ] **Step 3: Confirmar que o login funciona**

```bash
curl -s -X POST "https://iecvn333.us-east.insforge.app/api/auth/sessions" \
  -H "Authorization: Bearer anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "apikey: anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "Content-Type: application/json" \
  -d '{"email":"portoinforsistem@gmail.com","password":"<SENHA_GERADA>"}'
```

Esperado: JSON com `accessToken` e `user`.

---

### Task 9: Backend — migração RLS restrita ao admin

**Files:**
- Create: `migrations/` (via `npx @insforge/cli db migrations new restrict_admin_writes`)
- Modify: `supabase/schema.sql` (atualizar as políticas para refletir o estado final)
- Modify: `supabase/storage_policies.sql` (idem)

**Interfaces:**
- Consumes: email `portoinforsistem@gmail.com`; tabelas `courses`, `testimonials`, `features`, `about_data`, `contact_info`, `footer_config`, `financial_solutions`; buckets `courses` e `testimonials`.
- Produces: políticas de escrita exigindo `auth.email() = 'portoinforsistem@gmail.com'`; anon sem privilégio de escrita.

- [ ] **Step 1: Criar o arquivo de migração**

```bash
npx @insforge/cli db migrations new restrict_admin_writes
```

- [ ] **Step 2: Escrever o SQL da migração (tabelas public)**

No arquivo criado em `migrations/`:

```sql
-- Restringe escritas nas tabelas de conteúdo ao email do admin.
REVOKE INSERT, UPDATE, DELETE ON courses, testimonials, features, about_data, contact_info, footer_config, financial_solutions FROM anon;

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['courses','testimonials','features','about_data','contact_info','footer_config','financial_solutions']
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated insert %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin insert %I" ON public.%I FOR INSERT WITH CHECK (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated update %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin update %I" ON public.%I FOR UPDATE USING (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated delete %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin delete %I" ON public.%I FOR DELETE USING (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
  END LOOP;
END $$;
```

- [ ] **Step 3: Escrever o SQL da migração (storage)**

No mesmo arquivo (ou segundo arquivo `restrict_admin_storage_writes`):

```sql
DROP POLICY IF EXISTS "Allow authenticated uploads to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to courses bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated updates to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to courses bucket" ON storage.objects
FOR UPDATE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated deletes to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to courses bucket" ON storage.objects
FOR DELETE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated uploads to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to testimonials bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated updates to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to testimonials bucket" ON storage.objects
FOR UPDATE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated deletes to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to testimonials bucket" ON storage.objects
FOR DELETE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');
```

- [ ] **Step 4: Aplicar as migrações**

```bash
npx @insforge/cli db migrations up --all
```

- [ ] **Step 5: Verificar as políticas no backend**

```bash
npx @insforge/cli db policies
```

Esperado: políticas `Allow admin insert/update/delete <tabela>` com `qual`/`with_check` = `(auth.email() = 'portoinforsistem@gmail.com'::text)`; políticas antigas `Allow authenticated ...` removidas.

- [ ] **Step 6: Atualizar `supabase/schema.sql` e `supabase/storage_policies.sql`** para refletir as novas políticas (nome `Allow admin ...` com `auth.email()`), mantendo os arquivos locais como fonte de verdade.

---

### Task 10: Backend — verificação de autorização

**Files:**
- None (testes via curl).

**Interfaces:**
- Consumes: usuário admin (Task 8), RLS novo (Task 9), anon key.

- [ ] **Step 1: Login do admin para obter o JWT**

```bash
curl -s -X POST "https://iecvn333.us-east.insforge.app/api/auth/sessions" \
  -H "Authorization: Bearer anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "apikey: anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "Content-Type: application/json" \
  -d '{"email":"portoinforsistem@gmail.com","password":"<SENHA_GERADA>"}'
```

Guarde o `accessToken`.

- [ ] **Step 2: Escrita com a anon key DEVE falhar (403)**

```bash
curl -s -o /dev/null -w "%{http_code}\n" -X POST "https://iecvn333.us-east.insforge.app/api/database/records/courses" \
  -H "Authorization: Bearer anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "apikey: anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '[{"title":"TESTE NAO DEVE SALVAR","description":"x","category":"x","accent_color":"yellow"}]'
```

Esperado: HTTP 403.

- [ ] **Step 3: Escrita com o JWT do admin DEVE funcionar (200/201)**

```bash
curl -s -o /dev/null -w "%{http_code}\n" -X POST "https://iecvn333.us-east.insforge.app/api/database/records/courses" \
  -H "Authorization: Bearer <accessToken>" \
  -H "apikey: anon_c55c003438f989bd568406cdec2db756d433acdd03ceaee76da64fa4571f9ced" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '[{"title":"TESTE ADMIN","description":"x","category":"x","accent_color":"yellow"}]'
```

Esperado: 200/201. Depois, deletar a linha de teste (usando o JWT).

- [ ] **Step 4: Confirmar leitura pública continua funcionando**

```bash
curl -s -o /dev/null -w "%{http_code}\n" "https://iecvn333.us-east.insforge.app/api/database/records/courses?limit=1"
```

Esperado: 200.

---

### Task 11: Limpeza de constantes + verificação final

**Files:**
- Modify: `src/constants.ts`

**Interfaces:**
- Consumes: nada.
- Produces: nenhuma credencial hardcoded restante no frontend.

- [ ] **Step 1: Remover credenciais de `src/constants.ts`**

Delete as linhas finais:

```ts
export const ADMIN_EMAIL = 'admin@route364.com';
export const ADMIN_PASSWORD = 'admin123';
```

- [ ] **Step 2: Build e auditoria do bundle**

```bash
npm run build
grep -c "admin123" dist/assets/*.js || echo "OK: admin123 ausente"
grep -c "ik_ea6ee750c0cda41651202a89daf4e01f" dist/assets/*.js || echo "OK: admin key ausente"
grep -c "admin@route364.com" dist/assets/*.js || echo "OK: email antigo ausente"
```

Esperado: build PASS; nenhuma das strings aparece (contagem 0 / mensagem OK).

- [ ] **Step 3: Teste manual do fluxo completo**

1. `npm run dev`
2. Abrir `/admin`, logar com `portoinforsistem@gmail.com` + senha gerada.
3. Confirmar que navega para `/admin/dashboard` e que gerenciar cursos/depoimentos (incluindo upload de imagem) funciona.
4. Recarregar `/admin/dashboard` — sessão mantida.
5. Clicar "Sair" — volta para `/` e acessar `/admin/dashboard` redireciona para `/admin`.

- [ ] **Step 4: Registrar decisões no memory do projeto (InsForge)**

```bash
npx @insforge/cli memory remember "Auth admin do route364 usa InsForge Auth; admin email portoinforsistem@gmail.com; RLS restringe escritas a auth.email()='portoinforsistem@gmail.com'; anon key publica anon_c55c...; API_KEY de admin nunca no frontend" --kind decision
```

(Se o comando `memory` não existir na versão do CLI, ignorar e anotar no README.)

- [ ] **Step 5: Entregar ao usuário**

Apresentar: o email `portoinforsistem@gmail.com`, a senha gerada (mostrar UMA vez), e instrução para trocar a senha no painel/recuperação se desejado.

---

## Self-Review

**Spec coverage:**
- A (`.env` anon key) → Task 1 ✓
- B (auth real: composable, Login, guard, logout, boot) → Tasks 3,4,5,6 ✓
- C (escritas com JWT) → Task 7 ✓
- D (RLS admin) → Task 9 ✓
- E (limpeza constants) → Task 11 ✓
- F (verificação) → Tasks 1,10,11 ✓
- Criação do usuário admin → Task 8 ✓

**Placeholders:** nenhum; todos os passos têm código ou comando concreto.

**Consistência de tipos:** `useAuth()` exporta `ensureHydrated`, `signIn`, `signOut`, `getAccessToken`, `user`, `loading` — nomes usados consistentemente nas Tasks 3-7. `contentApi` usa `writeHeaders()`/`writeUploadHeaders()` consistentemente.
