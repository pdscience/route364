export interface NavItem {
  label: string;
  href: string;
}

export interface Course {
  id: number;
  title: string;
  description: string;
  descriptionComplete?: string;
  imageUrl: string;
  category: string;
  accentColor: 'yellow' | 'green' | 'blue' | 'gold';
  cargaHoraria?: number;
  modulos?: number;
  certificado?: boolean;
  modalidade?: string;
  modulosDetalhes?: string[];
  requisitos?: string[];
  isActive?: boolean;
}

export interface Testimonial {
  id: number;
  name: string;
  role: string;
  content: string;
  avatarUrl: string;
  isActive?: boolean;
}

export interface Feature {
  id: number;
  title: string;
  description: string;
  icon: 'monitor' | 'award' | 'users' | 'clock';
  color: 'yellow' | 'green' | 'blue' | 'gold';
  isActive?: boolean;
}

export interface AboutData {
  titlePrefix: string;
  titleHighlight: string;
  titleSuffix: string;
  description: string;
  subtitle?: string;
  isActive?: boolean;
}

export interface ContactInfo {
  sectionTitle: string;
  address: string;
  email: string;
  phone: string;
  whatsappNumber: string;
  whatsappLinkLabel: string;
  isActive?: boolean;
}

export interface SocialLinks {
  facebook: string;
  instagram: string;
  linkedin: string;
  twitter: string;
  youtube?: string;
  tiktok?: string;
}

export interface LinkItem {
  label: string;
  href: string;
}

export interface FooterConfig {
  subtitle?: string;
  socialLinks: SocialLinks;
  navigationColumns: {
    navTitle: string;
    navLinks: LinkItem[];
    supportTitle: string;
    supportLinks: LinkItem[];
  };
  copyrightText: string;
}

export interface FinancialSolution {
  id: number;
  title: string;
  description: string;
  icon?: string;
  isActive?: boolean;
  displayOrder?: number;
}
