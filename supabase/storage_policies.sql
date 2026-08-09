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

DROP POLICY IF EXISTS "Allow authenticated uploads to courses bucket" ON storage.objects;
CREATE POLICY "Allow authenticated uploads to courses bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'courses');

DROP POLICY IF EXISTS "Allow authenticated updates to courses bucket" ON storage.objects;
CREATE POLICY "Allow authenticated updates to courses bucket" ON storage.objects
FOR UPDATE USING (bucket = 'courses');

DROP POLICY IF EXISTS "Allow authenticated deletes to courses bucket" ON storage.objects;
CREATE POLICY "Allow authenticated deletes to courses bucket" ON storage.objects
FOR DELETE USING (bucket = 'courses');

-- Storage policies for testimonials bucket
DROP POLICY IF EXISTS "Public read access to testimonials bucket" ON storage.objects;
CREATE POLICY "Public read access to testimonials bucket" ON storage.objects
FOR SELECT USING (bucket = 'testimonials');

DROP POLICY IF EXISTS "Allow authenticated uploads to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow authenticated uploads to testimonials bucket" ON storage.objects
FOR INSERT WITH CHECK (bucket = 'testimonials');

DROP POLICY IF EXISTS "Allow authenticated updates to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow authenticated updates to testimonials bucket" ON storage.objects
FOR UPDATE USING (bucket = 'testimonials');

DROP POLICY IF EXISTS "Allow authenticated deletes to testimonials bucket" ON storage.objects;
CREATE POLICY "Allow authenticated deletes to testimonials bucket" ON storage.objects
FOR DELETE USING (bucket = 'testimonials');

-- Grant permissions
GRANT USAGE ON SCHEMA storage TO anon, authenticated;
GRANT ALL ON storage.objects TO anon, authenticated;
