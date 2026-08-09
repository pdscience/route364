<template>
  <div class="min-h-screen bg-brand-dark text-white selection:bg-brand-yellow selection:text-black">
    <Header />
    <main>
      <Hero />
      <About />
      <Courses />
      <Testimonials />
      <CTA />
    </main>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import Header from '../components/public/Header.vue';
import Hero from '../components/public/Hero.vue';
import About from '../components/public/About.vue';
import Courses from '../components/public/Courses.vue';
import Testimonials from '../components/public/Testimonials.vue';
import CTA from '../components/public/CTA.vue';
import Footer from '../components/public/Footer.vue';
</script>
