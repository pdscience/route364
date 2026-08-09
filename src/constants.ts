import type { Course, Feature, NavItem, Testimonial } from './types';

export const NAV_ITEMS: NavItem[] = [
  { label: "Início", href: "#home" },
  { label: "Sobre", href: "#about" },
  { label: "Cursos", href: "#courses" },
  { label: "Depoimentos", href: "#testimonials" },
];

export const FEATURES: Feature[] = [
  {
    id: 1,
    title: "Especialização Completa",
    description: "Cursos homologados e reconhecidos para motoristas profissionais em todo o Brasil.",
    icon: "award",
    color: "yellow",
  },
  {
    id: 2,
    title: "Metodologia na Estrada",
    description: "Conteúdo focado na realidade do transporte, com casos práticos e legislação atualizada.",
    icon: "monitor",
    color: "blue",
  },
  {
    id: 3,
    title: "Suporte ao Condutor",
    description: "Plantão de dúvidas e orientação profissional para sua carreira no transporte.",
    icon: "users",
    color: "green",
  },
  {
    id: 4,
    title: "Flexibilidade Total",
    description: "Estude nas paradas ou em casa. Acesso 24h pelo celular ou computador.",
    icon: "clock",
    color: "blue",
  }
];

export const COURSES: Course[] = [
  {
    id: 1,
    title: "Curso MOPP",
    description: "Movimentação Operacional de Produtos Perigosos. Essencial para o transporte de cargas especiais e químicas.",
    category: "Carga Especial",
    imageUrl: "/mopp_course_image_1769227751306.png",
    accentColor: "yellow",
  },
  {
    id: 2,
    title: "Transporte de Passageiros",
    description: "Especialize-se para conduzir veículos de transporte coletivo com segurança e profissionalismo.",
    category: "Coletivo",
    imageUrl: "/passenger_course_image_1769227767137.png",
    accentColor: "gold",
  },
  {
    id: 3,
    title: "Veículos de Emergência",
    description: "Treinamento avançado para condutores de ambulâncias, bombeiros e viaturas de socorro.",
    category: "Emergência",
    imageUrl: "/emergency_course_image_1769227786643.png",
    accentColor: "blue",
  },
];

export const TESTIMONIALS: Testimonial[] = [
  {
    id: 1,
    name: "Ricardo Santos",
    role: "Condutor MOPP",
    content: "A Route 364 superou minhas expectativas. Consegui minha certificação MOPP estudando nas pausas das viagens e agora estou em uma empresa melhor.",
    avatarUrl: "https://i.pravatar.cc/150?u=ricardo",
  },
  {
    id: 2,
    name: "Paulo Oliveira",
    role: "Motorista de Ônibus",
    content: "Excelente material. A parte de legislação para transporte de passageiros é muito completa e fácil de entender. Recomendo a todos os colegas.",
    avatarUrl: "https://i.pravatar.cc/150?u=paulo",
  },
  {
    id: 3,
    name: "Marcos Lima",
    role: "Socorrista",
    content: "O treinamento para veículos de emergência me deu muito mais segurança na condução da ambulância. Conteúdo de alto nível.",
    avatarUrl: "https://i.pravatar.cc/150?u=marcos",
  },
];

export const ADMIN_EMAIL = 'admin@route364.com';
export const ADMIN_PASSWORD = 'admin123';
