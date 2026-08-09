import { createRouter, createWebHistory } from 'vue-router';
import LandingPage from '../views/LandingPage.vue';
import Login from '../components/admin/Login.vue';
import Dashboard from '../components/admin/Dashboard.vue';
import CourseManager from '../components/admin/CourseManager.vue';
import TestimonialManager from '../components/admin/TestimonialManager.vue';
import AboutManager from '../components/admin/AboutManager.vue';
import ContactManager from '../components/admin/ContactManager.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'home',
      component: LandingPage
    },
    {
      path: '/admin',
      name: 'admin-login',
      component: Login
    },
    {
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      component: Dashboard,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/courses',
      name: 'admin-courses',
      component: CourseManager,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/testimonials',
      name: 'admin-testimonials',
      component: TestimonialManager,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/about',
      name: 'admin-about',
      component: AboutManager,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/contact',
      name: 'admin-contact',
      component: ContactManager,
      meta: { requiresAuth: true }
    }
  ]
});

// Navigation guard for admin routes
router.beforeEach((to, _from, next) => {
  const isAuthenticated = sessionStorage.getItem('admin_authenticated') === 'true';
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/admin');
  } else if (to.path === '/admin' && isAuthenticated) {
    next('/admin/dashboard');
  } else {
    next();
  }
});

export default router;
