#!/usr/bin/env node

// Test the API
const http = require('http');

function testEndpoint(path, method = 'GET', body = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: '127.0.0.1',
      port: 3000,
      path: path,
      method: method,
      timeout: 5000,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        resolve({ status: res.statusCode, data: data, path: path, method: method });
      });
    });

    req.on('error', (error) => {
      reject({ error: error.message, path: path });
    });

    req.on('timeout', () => {
      req.abort();
      reject({ error: 'Timeout', path: path });
    });

    if (body) {
      req.write(JSON.stringify(body));
    }

    req.end();
  });
}

async function runTests() {
  const tests = [
    { path: '/health', method: 'GET', desc: 'Health Check' },
    { path: '/products', method: 'GET', desc: 'Get All Products' },
    { 
      path: '/users', 
      method: 'POST', 
      body: {
        email: 'test@example.com',
        fullName: 'Test User',
        password: 'TestPass123',
        phoneNumber: '+1-555-0000'
      },
      desc: 'Create User'
    },
    { path: '/auth/login', method: 'POST', desc: 'Login (should fail without credentials)', body: {} },
  ];

  console.log('Testing NestJS API Endpoints\n');
  console.log('=====================================\n');

  let passed = 0, failed = 0;

  for (const test of tests) {
    try {
      const result = await testEndpoint(test.path, test.method, test.body);
      const success = result.status >= 200 && result.status < 400;
      const symbol = success ? '✅' : '⚠️';
      console.log(`${symbol} ${test.desc}`);
      console.log(`   ${test.method} ${test.path} → ${result.status}`);
      if (result.data) {
        const preview = result.data.substring(0, 80).replace(/\n/g, '');
        console.log(`   Response: ${preview}...`);
      }
      if (success) passed++;
      else failed++;
    } catch (err) {
      console.log(`❌ ${test.desc}`);
      console.log(`   ${test.method} ${test.path} → Error: ${err.error}`);
      failed++;
    }
    console.log('');
  }

  console.log('=====================================');
  console.log(`Results: ${passed} passed, ${failed} failed`);
  process.exit(0);
}

// Wait 3 seconds for server to start
setTimeout(runTests, 3000);

