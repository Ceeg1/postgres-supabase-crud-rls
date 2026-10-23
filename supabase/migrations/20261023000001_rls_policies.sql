-- 1. ENABLE ROW LEVEL SECURITY ON ALL TABLES
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.property_sponsors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inquiries ENABLE ROW LEVEL SECURITY;

-- 2. PROFILES POLICIES
CREATE POLICY "Public profiles are viewable by everyone" 
  ON public.profiles FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile" 
  ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- 3. PROPERTIES POLICIES
CREATE POLICY "Public can read approved properties" 
  ON public.properties FOR SELECT USING (is_approved = TRUE);

CREATE POLICY "Owners can view their own properties" 
  ON public.properties FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Owners can insert their own properties" 
  ON public.properties FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Owners can edit only their own unapproved records" 
  ON public.properties FOR UPDATE 
  USING (auth.uid() = owner_id AND is_approved = FALSE) 
  WITH CHECK (auth.uid() = owner_id AND is_approved = FALSE);

CREATE POLICY "Owners can delete their own unapproved records" 
  ON public.properties FOR DELETE 
  USING (auth.uid() = owner_id AND is_approved = FALSE);

-- 4. SPONSORS POLICIES
CREATE POLICY "Public can read active sponsors" 
  ON public.sponsors FOR SELECT USING (is_active = TRUE);

-- 5. PROPERTY_SPONSORS POLICIES
CREATE POLICY "Public can read property sponsors for approved properties" 
  ON public.property_sponsors FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.properties WHERE id = property_id AND is_approved = TRUE)
  );

-- 6. INQUIRIES POLICIES
CREATE POLICY "Authenticated users can create inquiries" 
  ON public.inquiries FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Property owners can read inquiries for their properties" 
  ON public.inquiries FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.properties WHERE id = property_id AND owner_id = auth.uid())
  );
