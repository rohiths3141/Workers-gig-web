const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  'https://uueddbdgfrosjxxduiaz.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1ZWRkYmRnZnJvc2p4eGR1aWF6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4OTIyOTI1NiwiZXhwIjoyMTA0ODA1MjU2fQ.lutz2C8SZdaIJ85NvGyey6tpEewu90dYo7qyjtjCz4E'
);

async function run() {
  // Check current enum values first
  const { data: enumData, error: enumErr } = await supabase.rpc('exec_sql', {
    query: "SELECT unnest(enum_range(NULL::public.booking_event_type))::text AS val"
  });
  
  if (enumErr) {
    console.log('Cannot use exec_sql RPC, trying direct approach...');
    // Use the pg module instead
    const { Pool } = require('pg');
    const pool = new Pool({
      connectionString: 'postgresql://postgres.uueddbdgfrosjxxduiaz:Rohith%40123@aws-0-ap-south-1.pooler.supabase.com:6543/postgres'
    });
    
    try {
      const client = await pool.connect();
      // Check existing values
      const res = await client.query("SELECT unnest(enum_range(NULL::public.booking_event_type))::text AS val");
      console.log('Current enum values:', res.rows.map(r => r.val));
      
      const hasRequested = res.rows.some(r => r.val === 'REQUESTED');
      if (hasRequested) {
        console.log('REQUESTED already exists in enum');
      } else {
        await client.query("ALTER TYPE public.booking_event_type ADD VALUE 'REQUESTED'");
        console.log('Added REQUESTED to booking_event_type enum');
      }
      client.release();
      await pool.end();
    } catch (e) {
      console.error('PG error:', e.message);
      // Try without pooler
      const pool2 = new Pool({
        connectionString: 'postgresql://postgres.uueddbdgfrosjxxduiaz:Rohith%40123@aws-0-ap-south-1.pooler.supabase.com:5432/postgres',
        ssl: { rejectUnauthorized: false }
      });
      try {
        const client2 = await pool2.connect();
        await client2.query("ALTER TYPE public.booking_event_type ADD VALUE IF NOT EXISTS 'REQUESTED'");
        console.log('Added REQUESTED to booking_event_type enum (via port 5432)');
        client2.release();
        await pool2.end();
      } catch (e2) {
        console.error('PG error 2:', e2.message);
      }
    }
  } else {
    console.log('Current enum values:', enumData);
  }
}

run().catch(console.error);
