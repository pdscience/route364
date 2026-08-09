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

// Type definitions for Supabase tables
export interface DbCourse {
  id: number;
  title: string;
  description: string;
  description_complete: string | null;
  image_url: string;
  category: string;
  accent_color: 'yellow' | 'green' | 'blue' | 'gold';
  carga_horaria: number | null;
  modulos: number | null;
  certificado: boolean | null;
  modalidade: string | null;
  modulos_detalhes: string[] | null;
  requisitos: string[] | null;
  is_active: boolean | null;
  created_at: string;
  updated_at: string;
}

export interface DbTestimonial {
  id: number;
  name: string;
  role: string;
  content: string;
  avatar_url: string;
  is_active: boolean | null;
  created_at: string;
  updated_at: string;
}

export interface DbFeature {
  id: number;
  title: string;
  description: string;
  icon: 'monitor' | 'award' | 'users' | 'clock';
  color: 'yellow' | 'green' | 'blue' | 'gold';
  is_active: boolean | null;
  created_at: string;
  updated_at: string;
}

export interface DbAboutData {
  id: number;
  title_prefix: string;
  title_highlight: string;
  title_suffix: string;
  description: string;
  subtitle: string | null;
  is_active: boolean | null;
  created_at: string;
  updated_at: string;
}

export interface DbContactInfo {
  id: number;
  section_title: string;
  address: string;
  email: string;
  phone: string;
  whatsapp_number: string;
  whatsapp_link_label: string;
  is_active: boolean | null;
  created_at: string;
  updated_at: string;
}

export interface DbFooterConfig {
  id: number;
  subtitle: string | null;
  social_links: {
    facebook: string;
    instagram: string;
    linkedin: string;
    twitter: string;
    youtube?: string;
    tiktok?: string;
  };
  navigation_columns: {
    navTitle: string;
    navLinks: { label: string; href: string }[];
    supportTitle: string;
    supportLinks: { label: string; href: string }[];
  };
  copyright_text: string;
  created_at: string;
  updated_at: string;
}

export interface DbFinancialSolution {
  id: number;
  title: string;
  description: string;
  icon: string | null;
  is_active: boolean | null;
  display_order: number | null;
  created_at: string;
  updated_at: string;
}
