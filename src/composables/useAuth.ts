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
