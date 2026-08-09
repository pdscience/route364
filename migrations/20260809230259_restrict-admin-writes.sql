-- Restringe escritas nas tabelas de conteúdo ao email do admin.
REVOKE INSERT, UPDATE, DELETE ON courses, testimonials, features, about_data, contact_info, footer_config, financial_solutions FROM anon;

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['courses','testimonials','features','about_data','contact_info','footer_config','financial_solutions']
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated insert %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin insert %I" ON public.%I FOR INSERT WITH CHECK (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated update %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin update %I" ON public.%I FOR UPDATE USING (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
    EXECUTE format('DROP POLICY IF EXISTS "Allow authenticated delete %I" ON public.%I', t, t);
    EXECUTE format('CREATE POLICY "Allow admin delete %I" ON public.%I FOR DELETE USING (auth.email() = ''portoinforsistem@gmail.com'')', t, t);
  END LOOP;
END $$;

DROP POLICY IF EXISTS "Allow authenticated uploads to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to courses bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated updates to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to courses bucket" ON storage.objects
FOR UPDATE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated deletes to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to courses bucket" ON storage.objects
FOR DELETE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated uploads to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to testimonials bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated updates to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to testimonials bucket" ON storage.objects
FOR UPDATE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow authenticated deletes to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to testimonials bucket" ON storage.objects
FOR DELETE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');
