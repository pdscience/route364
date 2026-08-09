import { ref } from 'vue';
import type { Course, Testimonial, Feature, AboutData, ContactInfo, FooterConfig } from '../types';
import { contentApi } from '../api/contentApi';
import { COURSES, TESTIMONIALS, FEATURES } from '../constants';

const initialAboutData: AboutData = {
  titlePrefix: "Por que escolher a",
  titleHighlight: "Route 364",
  titleSuffix: "?",
  description: "Somos especialistas na formação de motoristas profissionais. Com cursos homologados e metodologia flexível, preparamos você para os desafios das estradas brasileiras."
};

const initialContactInfo: ContactInfo = {
  sectionTitle: "Contato",
  address: "BR-364, KM 500\nPorto Velho, RO",
  email: "contato@route364.com",
  phone: "(69) 99999-9999",
  whatsappNumber: "5569999999999",
  whatsappLinkLabel: "Fale Conosco"
};

const initialFooterConfig: FooterConfig = {
  socialLinks: {
    facebook: "#",
    instagram: "#",
    linkedin: "#",
    twitter: "#"
  },
  navigationColumns: {
    navTitle: "Navegação",
    navLinks: [
      { label: "Início", href: "#" },
      { label: "Sobre Nós", href: "#" },
      { label: "Todos os Cursos", href: "#" },
      { label: "Instrutores", href: "#" },
      { label: "Blog", href: "#" }
    ],
    supportTitle: "Suporte",
    supportLinks: [
      { label: "Central de Ajuda", href: "#" },
      { label: "Termos de Uso", href: "#" },
      { label: "Política de Privacidade", href: "#" }
    ]
  },
  copyrightText: "Route 364 Formação Profissional. Todos os direitos reservados."
};

// Reactive state - initialized with default values
const courses = ref<Course[]>([...COURSES]);
const testimonials = ref<Testimonial[]>([...TESTIMONIALS]);
const features = ref<Feature[]>([...FEATURES]);
const aboutData = ref<AboutData>({ ...initialAboutData });
const contactInfo = ref<ContactInfo>({ ...initialContactInfo });
const footerConfig = ref<FooterConfig>({ ...initialFooterConfig });

// Loading state
const isLoading = ref(true);
const error = ref<string | null>(null);

// Function to load all data from Supabase
async function loadDataFromSupabase() {
  isLoading.value = true;
  error.value = null;
  
  try {
    // Load courses
    const loadedCourses = await contentApi.getCourses();
    if (loadedCourses.length > 0) {
      courses.value = loadedCourses;
    }
    
    // Load testimonials
    const loadedTestimonials = await contentApi.getTestimonials();
    if (loadedTestimonials.length > 0) {
      testimonials.value = loadedTestimonials;
    }
    
    // Load features
    const loadedFeatures = await contentApi.getFeatures();
    if (loadedFeatures.length > 0) {
      features.value = loadedFeatures;
    }
    
    // Load about data
    const loadedAbout = await contentApi.getAboutData();
    aboutData.value = loadedAbout;
    
    // Load contact info
    const loadedContact = await contentApi.getContactInfo();
    contactInfo.value = loadedContact;
    
    // Load footer config
    const loadedFooter = await contentApi.getFooterConfig();
    footerConfig.value = loadedFooter;
    
  } catch (e) {
    console.error('Error loading data from Supabase:', e);
    error.value = 'Failed to load data from server. Using default values.';
    // Keep using default values on error
  } finally {
    isLoading.value = false;
  }
}

export function useContent() {
  // Course functions
  const addCourse = async (course: Omit<Course, 'id'>) => {
    try {
      const newCourse = await contentApi.addCourse(course);
      courses.value = [...courses.value, newCourse];
    } catch (e) {
      console.error('Error adding course:', e);
      // Fallback to local-only add
      const localCourse = { ...course, id: Date.now() };
      courses.value = [...courses.value, localCourse];
    }
  };

const updateCourse = async (updatedCourse: Course) => {
    console.log('[useContent] updateCourse called with:', updatedCourse);
    try {
      const result = await contentApi.updateCourse(updatedCourse);
      console.log('[useContent] updateCourse result:', result);
      courses.value = courses.value.map(c => c.id === updatedCourse.id ? result : c);
    } catch (e) {
      console.error('[useContent] Error updating course:', e);
      courses.value = courses.value.map(c => c.id === updatedCourse.id ? updatedCourse : c);
    }
  };

  const deleteCourse = async (id: number) => {
    try {
      await contentApi.deleteCourse(id);
      courses.value = courses.value.filter(c => c.id !== id);
    } catch (e) {
      console.error('Error deleting course:', e);
      // Fallback to local-only delete
      courses.value = courses.value.filter(c => c.id !== id);
    }
  };

  // Testimonial functions
  const addTestimonial = async (testimonial: Omit<Testimonial, 'id'>) => {
    try {
      const newTestimonial = await contentApi.addTestimonial(testimonial);
      testimonials.value = [...testimonials.value, newTestimonial];
    } catch (e) {
      console.error('Error adding testimonial:', e);
      // Fallback to local-only add
      const localTestimonial = { ...testimonial, id: Date.now() };
      testimonials.value = [...testimonials.value, localTestimonial];
    }
  };

  const updateTestimonial = async (updatedTestimonial: Testimonial) => {
    try {
      const result = await contentApi.updateTestimonial(updatedTestimonial);
      testimonials.value = testimonials.value.map(t => t.id === updatedTestimonial.id ? result : t);
    } catch (e) {
      console.error('Error updating testimonial:', e);
      // Fallback to local-only update
      testimonials.value = testimonials.value.map(t => t.id === updatedTestimonial.id ? updatedTestimonial : t);
    }
  };

  const deleteTestimonial = async (id: number) => {
    try {
      await contentApi.deleteTestimonial(id);
      testimonials.value = testimonials.value.filter(t => t.id !== id);
    } catch (e) {
      console.error('Error deleting testimonial:', e);
      // Fallback to local-only delete
      testimonials.value = testimonials.value.filter(t => t.id !== id);
    }
  };

  // Feature functions
  const updateFeature = async (updatedFeature: Feature) => {
    try {
      const result = await contentApi.updateFeature(updatedFeature);
      features.value = features.value.map(f => f.id === updatedFeature.id ? result : f);
    } catch (e) {
      console.error('Error updating feature:', e);
      // Fallback to local-only update
      features.value = features.value.map(f => f.id === updatedFeature.id ? updatedFeature : f);
    }
  };

  // About functions
  const updateAboutData = async (data: AboutData) => {
    try {
      const result = await contentApi.updateAboutData(data);
      aboutData.value = result;
    } catch (e) {
      console.error('Error updating about data:', e);
      // Fallback to local-only update
      aboutData.value = { ...data };
    }
  };

  // Contact functions
  const updateContactInfo = async (data: ContactInfo) => {
    try {
      const result = await contentApi.updateContactInfo(data);
      contactInfo.value = result;
    } catch (e) {
      console.error('Error updating contact info:', e);
      // Fallback to local-only update
      contactInfo.value = { ...data };
    }
  };

  // Footer functions
  const updateFooterConfig = async (data: FooterConfig) => {
    try {
      const result = await contentApi.updateFooterConfig(data);
      footerConfig.value = result;
    } catch (e) {
      console.error('Error updating footer config:', e);
      // Fallback to local-only update
      footerConfig.value = { ...data };
    }
  };

  // Initialize data on first use
  if (isLoading.value) {
    loadDataFromSupabase();
  }

  return {
    courses,
    testimonials,
    features,
    aboutData,
    contactInfo,
    footerConfig,
    isLoading,
    error,
    loadDataFromSupabase,
    addCourse,
    updateCourse,
    deleteCourse,
    addTestimonial,
    updateTestimonial,
    deleteTestimonial,
    updateFeature,
    updateAboutData,
    updateContactInfo,
    updateFooterConfig
  };
}
