-- Habilita RLS nas tabelas de conteudo (as policies criadas na migracao anterior
-- nao surtiam efeito porque o RLS estava desativado e os grants de escrita
-- estavam em PUBLIC, nao apenas em anon).
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.features ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.about_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.footer_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.financial_solutions ENABLE ROW LEVEL SECURITY;

-- Remove grants de escrita de PUBLIC e anon. Mantem os grants de authenticated
-- para que o JWT do admin passe pelas policies "Allow admin insert/update/delete".
REVOKE INSERT, UPDATE, DELETE ON public.courses, public.testimonials, public.features, public.about_data, public.contact_info, public.footer_config, public.financial_solutions FROM PUBLIC;
REVOKE INSERT, UPDATE, DELETE ON public.courses, public.testimonials, public.features, public.about_data, public.contact_info, public.footer_config, public.financial_solutions FROM anon;

-- Garante leitura publica para anon e authenticated (as policies "Allow public read"
-- passam a valer com o RLS ativo).
GRANT SELECT ON public.courses, public.testimonials, public.features, public.about_data, public.contact_info, public.footer_config, public.financial_solutions TO anon, authenticated;

-- Storage: garante RLS ativo em storage.objects e remove as policies de upload
-- anonimo (buraco de seguranca). O admin usa as policies "Allow admin uploads/updates/deletes".
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon uploads to courses bucket" ON storage.objects;
DROP POLICY IF EXISTS "Allow anon uploads to testimonials bucket" ON storage.objects;
