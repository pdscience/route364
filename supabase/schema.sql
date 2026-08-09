-- Supabase Schema for Route364 Website Content Management
-- Updated: 2026-08-09

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if they exist (for clean migration)
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS testimonials CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS about_data CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;
DROP TABLE IF EXISTS footer_config CASCADE;
DROP TABLE IF EXISTS financial_solutions CASCADE;

-- Enable Row Level Security
ALTER TABLE IF EXISTS courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS features ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS about_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS footer_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS financial_solutions ENABLE ROW LEVEL SECURITY;

-- Create Courses Table (with detailed course information)
CREATE TABLE courses (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    description_complete TEXT,
    image_url TEXT NOT NULL,
    category TEXT NOT NULL,
    accent_color TEXT NOT NULL DEFAULT 'yellow',
    carga_horaria INTEGER DEFAULT 40,
    modulos INTEGER DEFAULT 8,
    certificado BOOLEAN DEFAULT true,
    modalidade TEXT DEFAULT 'Presencial',
    modulos_detalhes TEXT[],
    requisitos TEXT[],
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create Testimonials Table
CREATE TABLE testimonials (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT NOT NULL,
    content TEXT NOT NULL,
    avatar_url TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create Features Table
CREATE TABLE features (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    icon TEXT NOT NULL,
    color TEXT NOT NULL DEFAULT 'yellow',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create About Data Table (single row)
CREATE TABLE about_data (
    id BIGSERIAL PRIMARY KEY,
    title_prefix TEXT NOT NULL DEFAULT 'Por que escolher a',
    title_highlight TEXT NOT NULL DEFAULT 'Route 364',
    title_suffix TEXT NOT NULL DEFAULT '?',
    description TEXT NOT NULL,
    subtitle TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create Contact Info Table (single row)
CREATE TABLE contact_info (
    id BIGSERIAL PRIMARY KEY,
    section_title TEXT NOT NULL DEFAULT 'Contato',
    address TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    whatsapp_number TEXT NOT NULL,
    whatsapp_link_label TEXT DEFAULT 'Fale Conosco',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create Footer Config Table (single row)
CREATE TABLE footer_config (
    id BIGSERIAL PRIMARY KEY,
    subtitle TEXT DEFAULT 'Formação Profissional | Soluções Financeiras',
    social_links JSONB NOT NULL DEFAULT '{"facebook": "#", "instagram": "#", "linkedin": "#", "twitter": "#", "youtube": "", "tiktok": ""}'::jsonb,
    navigation_columns JSONB NOT NULL DEFAULT '{"navTitle": "Navegação", "navLinks": [{"label": "Início", "href": "#"}, {"label": "Sobre Nós", "href": "#about"}, {"label": "Todos os Cursos", "href": "#courses"}, {"label": "Instrutores", "href": "#"}, {"label": "Blog", "href": "#"}], "supportTitle": "Suporte", "supportLinks": [{"label": "Central de Ajuda", "href": "#"}, {"label": "Termos de Uso", "href": "#"}, {"label": "Política de Privacidade", "href": "#"}]}'::jsonb,
    copyright_text TEXT NOT NULL DEFAULT 'Route 364 Formação Profissional. Todos os direitos reservados.',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create Financial Solutions Table (new)
CREATE TABLE financial_solutions (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    icon TEXT DEFAULT 'CreditCard',
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Insert default data for single-row tables (only if empty)
INSERT INTO about_data (title_prefix, title_highlight, title_suffix, description, subtitle)
SELECT 'Por que escolher a', 'Route 364', '?', 
       'Somos especialistas na formação de motoristas profissionais. Com cursos homologados e metodologia flexível, preparamos você para os desafios das estradas brasileiras.',
       'Transformamos vocações em profissões com excelência e inovação.'
WHERE NOT EXISTS (SELECT 1 FROM about_data);

INSERT INTO contact_info (section_title, address, email, phone, whatsapp_number, whatsapp_link_label)
SELECT 'Contato', 'BR-364, KM 500
Porto Velho, RO', 'contato@route364.com', '(69) 99999-9999', '5569999999999', 'Fale Conosco'
WHERE NOT EXISTS (SELECT 1 FROM contact_info);

INSERT INTO footer_config (subtitle)
SELECT 'Formação Profissional | Soluções Financeiras'
WHERE NOT EXISTS (SELECT 1 FROM footer_config);

-- Insert default courses with detailed information (only if empty)
INSERT INTO courses (title, description, description_complete, image_url, category, accent_color, carga_horaria, modulos, certificado, modalidade)
SELECT 'Curso MOPP', 
       'Movimentação Operacional de Produtos Perigosos. Essencial para o transporte de cargas especiais e químicas.',
       'O curso MOPP (Movimentação Operacional de Produtos Perigosos) é obrigatório para motoristas que desejam transportar cargas perigosas.',
       '/mopp_course_image.png', 
       'Carga Especial', 
       'yellow', 40, 8, true, 'Presencial'
WHERE NOT EXISTS (SELECT 1 FROM courses);

INSERT INTO courses (title, description, description_complete, image_url, category, accent_color, carga_horaria, modulos, certificado, modalidade)
SELECT 'Transporte de Passageiros', 
       'Especialize-se para conduzir veículos de transporte coletivo com segurança e profissionalismo.',
       'O curso de Transporte de Passageiros prepara você para atuar como motorista de ônibus urbanos, intermunicipais e rodoviários.',
       '/passenger_course_image.png', 
       'Coletivo', 
       'gold', 60, 12, true, 'Presencial'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Transporte de Passageiros');

INSERT INTO courses (title, description, description_complete, image_url, category, accent_color, carga_horaria, modulos, certificado, modalidade)
SELECT 'Veículos de Emergência', 
       'Treinamento avançado para condutores de ambulâncias, bombeiros e viaturas de socorro.',
       'Este curso é destinado a profissionais que atuam ou desejam atuar em veículos de emergência.',
       '/emergency_course_image.png', 
       'Emergência', 
       'blue', 80, 16, true, 'Presencial'
WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Veículos de Emergência');

-- Insert default testimonials (only if empty)
INSERT INTO testimonials (name, role, content, avatar_url)
SELECT 'Ricardo Santos', 'Condutor MOPP', 'A Route 364 superou minhas expectativas. Consegui minha certificação MOPP estudando nas pausas das viagens e agora estou em uma empresa melhor.', 'https://i.pravatar.cc/150?u=ricardo'
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE name = 'Ricardo Santos');

INSERT INTO testimonials (name, role, content, avatar_url)
SELECT 'Paulo Oliveira', 'Motorista de Ônibus', 'Excelente material. A parte de legislação para transporte de passageiros é muito completa e fácil de entender. Recomendo a todos os colegas.', 'https://i.pravatar.cc/150?u=paulo'
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE name = 'Paulo Oliveira');

INSERT INTO testimonials (name, role, content, avatar_url)
SELECT 'Marcos Lima', 'Socorrista', 'O treinamento para veículos de emergência me deu muito mais segurança na condução da ambulância. Conteúdo de alto nível.', 'https://i.pravatar.cc/150?u=marcos'
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE name = 'Marcos Lima');

-- Insert default features (only if empty)
INSERT INTO features (title, description, icon, color)
SELECT 'Especialização Completa', 'Cursos homologados e reconhecidos para motoristas profissionais em todo o Brasil.', 'award', 'yellow'
WHERE NOT EXISTS (SELECT 1 FROM features WHERE title = 'Especialização Completa');

INSERT INTO features (title, description, icon, color)
SELECT 'Metodologia na Estrada', 'Conteúdo focado na realidade do transporte, com casos práticos e legislação atualizada.', 'monitor', 'blue'
WHERE NOT EXISTS (SELECT 1 FROM features WHERE title = 'Metodologia na Estrada');

INSERT INTO features (title, description, icon, color)
SELECT 'Suporte ao Condutor', 'Plantão de dúvidas e orientação profissional para sua carreira no transporte.', 'users', 'green'
WHERE NOT EXISTS (SELECT 1 FROM features WHERE title = 'Suporte ao Condutor');

INSERT INTO features (title, description, icon, color)
SELECT 'Flexibilidade Total', 'Estude nas paradas ou em casa. Acesso 24h pelo celular ou computador.', 'clock', 'blue'
WHERE NOT EXISTS (SELECT 1 FROM features WHERE title = 'Flexibilidade Total');

-- Insert default financial solutions (only if empty)
INSERT INTO financial_solutions (title, description, icon, display_order)
SELECT 'Financiamento Facilitado', 'Parcele sua formação em até 12x sem juros. Condições especiais para profissionais do transporte.', 'CreditCard', 1
WHERE NOT EXISTS (SELECT 1 FROM financial_solutions WHERE title = 'Financiamento Facilitado');

INSERT INTO financial_solutions (title, description, icon, display_order)
SELECT 'Boleto Parceria', 'Pagamento via boleto bancário com desconto de até 10%. Aprovação rápida e sem burocracia.', 'Receipt', 2
WHERE NOT EXISTS (SELECT 1 FROM financial_solutions WHERE title = 'Boleto Parceria');

INSERT INTO financial_solutions (title, description, icon, display_order)
SELECT 'Convênios Empresariais', 'Acertos direto com empresas de transporte. Forme seus motorista com condições especiais.', 'Building2', 3
WHERE NOT EXISTS (SELECT 1 FROM financial_solutions WHERE title = 'Convênios Empresariais');

INSERT INTO financial_solutions (title, description, icon, display_order)
SELECT 'Bolsa Profissional', 'Candidate-se a bolsas parciais de até 50%. Turmas com vagas limitadas.', 'GraduationCap', 4
WHERE NOT EXISTS (SELECT 1 FROM financial_solutions WHERE title = 'Bolsa Profissional');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
DROP TRIGGER IF EXISTS update_courses_updated_at ON courses;
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_testimonials_updated_at ON testimonials;
CREATE TRIGGER update_testimonials_updated_at BEFORE UPDATE ON testimonials
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_features_updated_at ON features;
CREATE TRIGGER update_features_updated_at BEFORE UPDATE ON features
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_about_data_updated_at ON about_data;
CREATE TRIGGER update_about_data_updated_at BEFORE UPDATE ON about_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_contact_info_updated_at ON contact_info;
CREATE TRIGGER update_contact_info_updated_at BEFORE UPDATE ON contact_info
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_footer_config_updated_at ON footer_config;
CREATE TRIGGER update_footer_config_updated_at BEFORE UPDATE ON footer_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_financial_solutions_updated_at ON financial_solutions;
CREATE TRIGGER update_financial_solutions_updated_at BEFORE UPDATE ON financial_solutions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Revoke write privileges from anon on content tables
REVOKE INSERT, UPDATE, DELETE ON courses, testimonials, features, about_data, contact_info, footer_config, financial_solutions FROM anon;

-- Create RLS Policies (allow public read, admin-only write via auth.email())
-- Writes are restricted to the admin email: portoinforsistem@gmail.com
-- For courses
DROP POLICY IF EXISTS "Allow public read courses" ON courses;
CREATE POLICY "Allow public read courses" ON courses FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert courses" ON courses;
CREATE POLICY "Allow admin insert courses" ON courses FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update courses" ON courses;
CREATE POLICY "Allow admin update courses" ON courses FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete courses" ON courses;
CREATE POLICY "Allow admin delete courses" ON courses FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For testimonials
DROP POLICY IF EXISTS "Allow public read testimonials" ON testimonials;
CREATE POLICY "Allow public read testimonials" ON testimonials FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert testimonials" ON testimonials;
CREATE POLICY "Allow admin insert testimonials" ON testimonials FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update testimonials" ON testimonials;
CREATE POLICY "Allow admin update testimonials" ON testimonials FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete testimonials" ON testimonials;
CREATE POLICY "Allow admin delete testimonials" ON testimonials FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For features
DROP POLICY IF EXISTS "Allow public read features" ON features;
CREATE POLICY "Allow public read features" ON features FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert features" ON features;
CREATE POLICY "Allow admin insert features" ON features FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update features" ON features;
CREATE POLICY "Allow admin update features" ON features FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete features" ON features;
CREATE POLICY "Allow admin delete features" ON features FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For about_data
DROP POLICY IF EXISTS "Allow public read about_data" ON about_data;
CREATE POLICY "Allow public read about_data" ON about_data FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert about_data" ON about_data;
CREATE POLICY "Allow admin insert about_data" ON about_data FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update about_data" ON about_data;
CREATE POLICY "Allow admin update about_data" ON about_data FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete about_data" ON about_data;
CREATE POLICY "Allow admin delete about_data" ON about_data FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For contact_info
DROP POLICY IF EXISTS "Allow public read contact_info" ON contact_info;
CREATE POLICY "Allow public read contact_info" ON contact_info FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert contact_info" ON contact_info;
CREATE POLICY "Allow admin insert contact_info" ON contact_info FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update contact_info" ON contact_info;
CREATE POLICY "Allow admin update contact_info" ON contact_info FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete contact_info" ON contact_info;
CREATE POLICY "Allow admin delete contact_info" ON contact_info FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For footer_config
DROP POLICY IF EXISTS "Allow public read footer_config" ON footer_config;
CREATE POLICY "Allow public read footer_config" ON footer_config FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert footer_config" ON footer_config;
CREATE POLICY "Allow admin insert footer_config" ON footer_config FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update footer_config" ON footer_config;
CREATE POLICY "Allow admin update footer_config" ON footer_config FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete footer_config" ON footer_config;
CREATE POLICY "Allow admin delete footer_config" ON footer_config FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');

-- For financial_solutions
DROP POLICY IF EXISTS "Allow public read financial_solutions" ON financial_solutions;
CREATE POLICY "Allow public read financial_solutions" ON financial_solutions FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow admin insert financial_solutions" ON financial_solutions;
CREATE POLICY "Allow admin insert financial_solutions" ON financial_solutions FOR INSERT WITH CHECK (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin update financial_solutions" ON financial_solutions;
CREATE POLICY "Allow admin update financial_solutions" ON financial_solutions FOR UPDATE USING (auth.email() = 'portoinforsistem@gmail.com');
DROP POLICY IF EXISTS "Allow admin delete financial_solutions" ON financial_solutions;
CREATE POLICY "Allow admin delete financial_solutions" ON financial_solutions FOR DELETE USING (auth.email() = 'portoinforsistem@gmail.com');
