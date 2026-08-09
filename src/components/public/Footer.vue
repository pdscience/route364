<template>
  <footer class="clay-nav pt-20 pb-10">
    <div class="max-w-7xl mx-auto px-4 md:px-8">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
        <div class="col-span-1 md:col-span-1">
          <div class="flex items-center gap-4 mb-6">
            <div class="relative w-12 h-12 flex items-center justify-center">
              <img src="/logo_route364.jpg" alt="Route 364 Logo" loading="lazy" class="w-full h-full object-contain rounded-full border border-brand-gold/20 p-1 bg-white" />
            </div>
            <div class="flex flex-col">
              <span class="font-black text-xl tracking-tighter text-white leading-none italic uppercase">
                ROUTE <span class="text-brand-gold">364</span>
              </span>
              <span class="text-[0.6rem] font-bold text-brand-gold uppercase tracking-[0.2em] leading-tight">
                Formação Profissional | Soluções Financeiras
              </span>
            </div>
          </div>
          <p class="text-gray-400 text-sm leading-relaxed mb-6">
            Formando profissionais qualificados para o mercado de trabalho com excelência e inovação. Seu futuro em movimento.
          </p>
          <div class="flex gap-3">
            <template v-for="(url, key) in footerConfig.socialLinks" :key="key">
              <a
                v-if="url"
                :href="url"
                target="_blank"
                rel="noopener noreferrer"
                class="w-10 h-10 rounded-full clay-card flex items-center justify-center text-gray-400 hover:text-black transition-all hover:scale-110"
                :class="socialHoverClass"
              >
                <component :is="getIcon(key)" :size="18" />
              </a>
            </template>
          </div>
        </div>

        <div>
          <h4 class="text-white font-bold mb-6">{{ footerConfig.navigationColumns.navTitle }}</h4>
          <ul class="space-y-3 text-sm text-gray-400">
            <li v-for="(link, index) in footerConfig.navigationColumns.navLinks" :key="index">
              <a :href="link.href" class="hover:text-brand-gold transition-colors">{{ link.label }}</a>
            </li>
          </ul>
        </div>

        <div>
          <h4 class="text-white font-bold mb-6">{{ footerConfig.navigationColumns.supportTitle }}</h4>
          <ul class="space-y-3 text-sm text-gray-400">
            <li v-for="(link, index) in footerConfig.navigationColumns.supportLinks" :key="index">
              <a :href="link.href" class="hover:text-brand-gold transition-colors">{{ link.label }}</a>
            </li>
            <li>
              <a href="#" class="hover:text-brand-gold transition-colors">{{ contactInfo.whatsappLinkLabel }}</a>
            </li>
          </ul>
        </div>

        <div>
          <h4 class="text-white font-bold mb-6">{{ contactInfo.sectionTitle }}</h4>
          <ul class="space-y-4 text-sm text-gray-400">
            <li class="flex items-start gap-3">
              <MapPin :size="18" class="text-brand-gold mt-0.5 shrink-0" />
              <span class="whitespace-pre-line">{{ contactInfo.address }}</span>
            </li>
            <li class="flex items-center gap-3">
              <Mail :size="18" class="text-brand-gold shrink-0" />
              <span>{{ contactInfo.email }}</span>
            </li>
            <li class="flex items-center gap-3">
              <Phone :size="18" class="text-brand-gold shrink-0" />
              <span>{{ contactInfo.phone }}</span>
            </li>
          </ul>
        </div>
      </div>

      <div class="border-t border-white/5 pt-8 flex flex-col md:flex-row justify-between items-center text-gray-500 text-sm gap-4">
        <p>© {{ new Date().getFullYear() }} {{ footerConfig.copyrightText }}</p>

        <router-link
          to="/admin"
          class="flex items-center gap-2 opacity-50 hover:opacity-100 hover:text-brand-gold transition-all"
          title="Acesso Restrito"
        >
          <Lock :size="14" />
          <span>Área Administrativa</span>
        </router-link>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { Facebook, Instagram, Linkedin, Twitter, Youtube, Mail, Phone, MapPin, Lock } from 'lucide-vue-next';
import { useContent } from '../../composables/useContent';

const { contactInfo, footerConfig } = useContent();

const socialIcons: Record<string, any> = {
  facebook: Facebook,
  instagram: Instagram,
  linkedin: Linkedin,
  twitter: Twitter,
  youtube: Youtube
};

const socialHoverClass = computed(() => 'hover:bg-brand-gold');

const getIcon = (key: string) => {
  return socialIcons[key] || Facebook;
};
</script>
