import { insforgeBaseUrl, insforgeApiKey, type DbCourse, type DbTestimonial, type DbFeature, type DbAboutData, type DbContactInfo, type DbFooterConfig, type DbFinancialSolution } from '../lib/supabase';
import type { Course, Testimonial, Feature, AboutData, ContactInfo, FooterConfig, FinancialSolution } from '../types';

const apiUrl = insforgeBaseUrl;
const apiKey = insforgeApiKey;

const authHeaders = {
  'Authorization': `Bearer ${apiKey}`,
  'apikey': apiKey,
  'Content-Type': 'application/json'
};

async function fetchApi(endpoint: string, options: RequestInit = {}) {
  const response = await fetch(`${apiUrl}${endpoint}`, {
    ...options,
    headers: { ...authHeaders, ...options.headers }
  });
  if (!response.ok) {
    const error = await response.json().catch(() => ({ message: response.statusText }));
    throw new Error(error.message || error.error || 'API Error');
  }
  const text = await response.text();
  return text ? JSON.parse(text) : null;
}

function mapDbToCourse(db: DbCourse): Course {
  return {
    id: db.id,
    title: db.title,
    description: db.description,
    descriptionComplete: db.description_complete || undefined,
    imageUrl: db.image_url,
    category: db.category,
    accentColor: db.accent_color,
    cargaHoraria: db.carga_horaria || undefined,
    modulos: db.modulos || undefined,
    certificado: db.certificado || undefined,
    modalidade: db.modalidade || undefined,
    modulosDetalhes: db.modulos_detalhes || undefined,
    requisitos: db.requisitos || undefined,
    isActive: db.is_active || undefined,
  };
}

function mapDbToTestimonial(db: DbTestimonial): Testimonial {
  return {
    id: db.id,
    name: db.name,
    role: db.role,
    content: db.content,
    avatarUrl: db.avatar_url,
  };
}

function mapDbToFeature(db: DbFeature): Feature {
  return {
    id: db.id,
    title: db.title,
    description: db.description,
    icon: db.icon,
    color: db.color,
  };
}

function mapDbToContactInfo(db: DbContactInfo): ContactInfo {
  return {
    sectionTitle: db.section_title,
    address: db.address,
    email: db.email,
    phone: db.phone,
    whatsappNumber: db.whatsapp_number,
    whatsappLinkLabel: db.whatsapp_link_label,
  };
}

function mapDbToFooterConfig(db: DbFooterConfig): FooterConfig {
  return {
    subtitle: db.subtitle || undefined,
    socialLinks: db.social_links,
    navigationColumns: db.navigation_columns,
    copyrightText: db.copyright_text,
  };
}

function mapDbToAboutData(db: DbAboutData): AboutData {
  return {
    titlePrefix: db.title_prefix,
    titleHighlight: db.title_highlight,
    titleSuffix: db.title_suffix,
    description: db.description,
    subtitle: db.subtitle || undefined,
  };
}

function mapDbToFinancialSolution(db: DbFinancialSolution): FinancialSolution {
  return {
    id: db.id,
    title: db.title,
    description: db.description,
    icon: db.icon || undefined,
    isActive: db.is_active || undefined,
    displayOrder: db.display_order || undefined,
  };
}

async function uploadTestimonialAvatar(file: File): Promise<string> {
  const formData = new FormData();
  formData.append('file', file);
  
  const response = await fetch(`${apiUrl}/api/storage/buckets/testimonials/objects`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'apikey': apiKey
    },
    body: formData
  });
  
  if (!response.ok) {
    const result = await response.json().catch(() => ({}));
    throw new Error(`Falha ao fazer upload do avatar: ${result.message || result.error || 'Upload failed'}`);
  }

  const data = await response.json();
  return data.url;
}

async function uploadCourseImage(file: File): Promise<string> {
  const formData = new FormData();
  formData.append('file', file);
  
  const response = await fetch(`${apiUrl}/api/storage/buckets/courses/objects`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'apikey': apiKey
    },
    body: formData
  });
  
  if (!response.ok) {
    const result = await response.json().catch(() => ({}));
    throw new Error(`Falha ao fazer upload da imagem: ${result.message || result.error || 'Upload failed'}`);
  }

  const data = await response.json();
  return data.url;
}

export const contentApi = {
  async uploadTestimonialAvatar(file: File): Promise<string> {
    return uploadTestimonialAvatar(file);
  },

  async uploadCourseImage(file: File): Promise<string> {
    return uploadCourseImage(file);
  },

  async getCourses(): Promise<Course[]> {
    const data = await fetchApi('/api/database/records/courses?order=id');
    return data.map(mapDbToCourse);
  },

  async addCourse(course: Omit<Course, 'id'>): Promise<Course> {
    const [result] = await fetchApi('/api/database/records/courses', {
      method: 'POST',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify([{
        title: course.title,
        description: course.description,
        description_complete: course.descriptionComplete,
        image_url: course.imageUrl,
        category: course.category,
        accent_color: course.accentColor,
        carga_horaria: course.cargaHoraria,
        modulos: course.modulos,
        certificado: course.certificado,
        modalidade: course.modalidade,
        modulos_detalhes: course.modulosDetalhes,
        requisitos: course.requisitos,
      }])
    });
    return mapDbToCourse(result);
  },

  async updateCourse(course: Course): Promise<Course> {
    const [result] = await fetchApi(`/api/database/records/courses?id=eq.${course.id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        title: course.title,
        description: course.description,
        description_complete: course.descriptionComplete,
        image_url: course.imageUrl,
        category: course.category,
        accent_color: course.accentColor,
        carga_horaria: course.cargaHoraria,
        modulos: course.modulos,
        certificado: course.certificado,
        modalidade: course.modalidade,
        modulos_detalhes: course.modulosDetalhes,
        requisitos: course.requisitos,
      })
    });
    return mapDbToCourse(result);
  },

  async deleteCourse(id: number): Promise<void> {
    await fetchApi(`/api/database/records/courses?id=eq.${id}`, { method: 'DELETE' });
  },

  async getTestimonials(): Promise<Testimonial[]> {
    const data = await fetchApi('/api/database/records/testimonials?order=id');
    return data.map(mapDbToTestimonial);
  },

  async addTestimonial(testimonial: Omit<Testimonial, 'id'>): Promise<Testimonial> {
    const [result] = await fetchApi('/api/database/records/testimonials', {
      method: 'POST',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify([{
        name: testimonial.name,
        role: testimonial.role,
        content: testimonial.content,
        avatar_url: testimonial.avatarUrl,
      }])
    });
    return mapDbToTestimonial(result);
  },

  async updateTestimonial(testimonial: Testimonial): Promise<Testimonial> {
    const [result] = await fetchApi(`/api/database/records/testimonials?id=eq.${testimonial.id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        name: testimonial.name,
        role: testimonial.role,
        content: testimonial.content,
        avatar_url: testimonial.avatarUrl,
      })
    });
    return mapDbToTestimonial(result);
  },

  async deleteTestimonial(id: number): Promise<void> {
    await fetchApi(`/api/database/records/testimonials?id=eq.${id}`, { method: 'DELETE' });
  },

  async getFeatures(): Promise<Feature[]> {
    const data = await fetchApi('/api/database/records/features?order=id');
    return data.map(mapDbToFeature);
  },

  async updateFeature(feature: Feature): Promise<Feature> {
    const [result] = await fetchApi(`/api/database/records/features?id=eq.${feature.id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        title: feature.title,
        description: feature.description,
        icon: feature.icon,
        color: feature.color,
      })
    });
    return mapDbToFeature(result);
  },

  async getAboutData(): Promise<AboutData> {
    const data = await fetchApi('/api/database/records/about_data?limit=1');
    return mapDbToAboutData(data[0]);
  },

  async updateAboutData(dataToUpdate: AboutData): Promise<AboutData> {
    const [result] = await fetchApi('/api/database/records/about_data?id=eq.1', {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        title_prefix: dataToUpdate.titlePrefix,
        title_highlight: dataToUpdate.titleHighlight,
        title_suffix: dataToUpdate.titleSuffix,
        description: dataToUpdate.description,
      })
    });
    return mapDbToAboutData(result);
  },

  async getContactInfo(): Promise<ContactInfo> {
    const data = await fetchApi('/api/database/records/contact_info?limit=1');
    return mapDbToContactInfo(data[0]);
  },

  async updateContactInfo(dataToUpdate: ContactInfo): Promise<ContactInfo> {
    const [result] = await fetchApi('/api/database/records/contact_info?id=eq.1', {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        section_title: dataToUpdate.sectionTitle,
        address: dataToUpdate.address,
        email: dataToUpdate.email,
        phone: dataToUpdate.phone,
        whatsapp_number: dataToUpdate.whatsappNumber,
        whatsapp_link_label: dataToUpdate.whatsappLinkLabel,
      })
    });
    return mapDbToContactInfo(result);
  },

  async getFooterConfig(): Promise<FooterConfig> {
    const data = await fetchApi('/api/database/records/footer_config?limit=1');
    return mapDbToFooterConfig(data[0]);
  },

  async updateFooterConfig(dataToUpdate: FooterConfig): Promise<FooterConfig> {
    const [result] = await fetchApi('/api/database/records/footer_config?id=eq.1', {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        social_links: dataToUpdate.socialLinks,
        navigation_columns: dataToUpdate.navigationColumns,
        copyright_text: dataToUpdate.copyrightText,
      })
    });
    return mapDbToFooterConfig(result);
  },

  async getFinancialSolutions(): Promise<FinancialSolution[]> {
    const data = await fetchApi('/api/database/records/financial_solutions?order=display_order');
    return data.map(mapDbToFinancialSolution);
  },

  async addFinancialSolution(solution: Omit<FinancialSolution, 'id'>): Promise<FinancialSolution> {
    const [result] = await fetchApi('/api/database/records/financial_solutions', {
      method: 'POST',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify([{
        title: solution.title,
        description: solution.description,
        icon: solution.icon,
        display_order: solution.displayOrder,
      }])
    });
    return mapDbToFinancialSolution(result);
  },

  async updateFinancialSolution(solution: FinancialSolution): Promise<FinancialSolution> {
    const [result] = await fetchApi(`/api/database/records/financial_solutions?id=eq.${solution.id}`, {
      method: 'PATCH',
      headers: { 'Prefer': 'return=representation' },
      body: JSON.stringify({
        title: solution.title,
        description: solution.description,
        icon: solution.icon,
        display_order: solution.displayOrder,
        is_active: solution.isActive,
      })
    });
    return mapDbToFinancialSolution(result);
  },

  async deleteFinancialSolution(id: number): Promise<void> {
    await fetchApi(`/api/database/records/financial_solutions?id=eq.${id}`, { method: 'DELETE' });
  },
};