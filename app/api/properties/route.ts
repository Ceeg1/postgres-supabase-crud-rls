import { NextResponse } from 'next/server'
import { createClient } from '@/utils/supabase/server'

export async function GET() {
  try {
    const supabase = createClient()

    // Fetch only approved properties with explicit columns
    const { data, error } = await supabase
      .from('properties')
      .select('id, title, description, price, created_at')
      .eq('is_approved', true)
      .order('created_at', { ascending: false })

    if (error) {
      return NextResponse.json({ error: 'Failed to fetch properties' }, { status: 500 })
    }

    return NextResponse.json({ data }, { status: 200 })
  } catch (err) {
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 })
  }
}
