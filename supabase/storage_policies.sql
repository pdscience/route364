-- ============================================
-- STORAGE POLICIES FOR IMAGES
-- ============================================
-- IMPORTANT: You must first create the buckets manually in Supabase Dashboard
-- Go to: Storage -> New Bucket
-- Create two buckets:
--   1. Name: "courses" - Public bucket
--   2. Name: "testimonials" - Public bucket
--
-- After creating the buckets, run this SQL to add the policies
-- ============================================

-- Storage policies for courses bucket
DROP POLICY IF EXISTS "Public read access to courses bucket" ON storage.objects;
CREATE POLICY "Public read access to courses bucket" ON storage.objects
FOR SELECT USING (bucket = 'courses');

DROP POLICY IF EXISTS "Allow admin uploads to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to courses bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow admin updates to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to courses bucket" ON storage.objects
FOR UPDATE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow admin deletes to courses bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to courses bucket" ON storage.objects
FOR DELETE USING (bucket = 'courses' AND auth.email() = 'portoinforsistem@gmail.com');

-- Storage policies for testimonials bucket
DROP POLICY IF EXISTS "Public read access to testimonials bucket" ON storage.objects;
CREATE POLICY "Public read access to testimonials bucket" ON storage.objects
FOR SELECT USING (bucket = 'testimonials');

DROP POLICY IF EXISTS "Allow admin uploads to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin uploads to testimonials bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow admin updates to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin updates to testimonials bucket" ON storage.objects
FOR UPDATE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

DROP POLICY IF EXISTS "Allow admin deletes to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow admin deletes to testimonials bucket" ON storage.objects
FOR DELETE USING (bucket = 'testimonials' AND auth.email() = 'portoinforsistem@gmail.com');

-- Grant permissions (anon gets read only; writes are restricted to the admin via policies)
GRANT USAGE ON SCHEMA storage TO anon, authenticated;
GRANT SELECT ON storage.objects TO anon, authenticated;
