#!/usr/bin/env node

const http = require('http');

let testResults = {
  passed: 0,
  failed: 0,
  endpoints: []
};

// Global token for authenticated requests
let authToken = null;
let userId = null;
let productId = null;

function makeRequest(path, method = 'GET', body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: '127.0.0.1',
      port: 3000,
      path: path,
      method: method,
      timeout: 5000,
      headers: {
        'Content-Type': 'application/json',
        ...headers
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => { data += chunk; });
      res.on('end', () => {
        try {
          const parsed = data ? JSON.parse(data) : null;
          resolve({ status: res.statusCode, data: parsed, raw: data });
        } catch (e) {
          resolve({ status: res.statusCode, data: null, raw: data });
        }
      });
    });

    req.on('error', reject);
    req.on('timeout', () => { req.abort(); reject(new Error('Timeout')); });

    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

function test(name, path, method = 'GET', body = null, expectedStatus = 200, headers = {}) {
  return makeRequest(path, method, body, headers).then(result => {
    const success = result.status === expectedStatus;
    const status = success ? '✅' : '❌';
    console.log(`${status} ${name}`);
    console.log(`   ${method} ${path} → ${result.status} (expected ${expectedStatus})`);
    
    if (result.data) {
      if (typeof result.data === 'object') {
        const keys = Object.keys(result.data).slice(0, 3).join(', ');
        console.log(`   Response keys: [${keys}...]`);
      }
    }
    
    testResults.endpoints.push({ name, method, path, status: result.status, success });
    if (success) testResults.passed++;
    else testResults.failed++;
    
    return result;
  }).catch(err => {
    console.log(`❌ ${name}`);
    console.log(`   ${method} ${path} → Error: ${err.message}`);
    testResults.endpoints.push({ name, method, path, status: 'ERROR', success: false });
    testResults.failed++;
    return null;
  });
}

async function runAllTests() {
  console.log('\n========== NestJS API COMPREHENSIVE TEST ==========\n');
  
  // 1. HEALTH ENDPOINTS (2)
  console.log('📋 HEALTH ENDPOINTS\n');
  let result = await test('Health Check', '/health', 'GET');
  result = await test('Root Endpoint', '/', 'GET');
  
  // 2. USER ENDPOINTS (5)
  console.log('\n📋 USER ENDPOINTS\n');
  
  // Create user
  result = await test('Create User (Registration)', '/users', 'POST', {
    email: `user${Date.now()}@test.com`,
    fullName: 'Test User',
    password: 'TestPass123',
    phoneNumber: '+1-555-0001'
  }, 201);
  if (result?.data?.id) {
    userId = result.data.id;
    console.log(`   Captured userId: ${userId}`);
  }
  
  // Login
  const email = result?.data?.email || `user${Date.now()}@test.com`;
  const loginBody = {
    email: email,
    password: 'TestPass123'
  };
  result = await test('Login User', '/auth/login', 'POST', loginBody, 200);
  if (result?.data?.access_token) {
    authToken = result.data.access_token;
    console.log(`   Captured authToken`);
  }
  
  // Get all users (requires auth)
  const authHeader = authToken ? { 'Authorization': `Bearer ${authToken}` } : {};
  result = await test('Get All Users (Protected)', '/users', 'GET', null, authToken ? 200 : 401, authHeader);
  
  // Get specific user (requires auth)
  if (userId) {
    result = await test('Get User by ID (Protected)', `/users/${userId}`, 'GET', null, authToken ? 200 : 401, authHeader);
  }
  
  // Update user (requires auth)
  if (userId) {
    result = await test('Update User (Protected)', `/users/${userId}`, 'PATCH', {
      fullName: 'Updated Name'
    }, authToken ? 200 : 401, authHeader);
  }
  
  // Delete user (requires auth + admin)
  if (userId) {
    result = await test('Delete User (Protected+Admin)', `/users/${userId}`, 'DELETE', null, authToken ? 403 : 401, authHeader);
  }
  
  // 3. AUTH ENDPOINTS (2)
  console.log('\n📋 AUTH ENDPOINTS\n');
  
  // Profile (requires auth)
  result = await test('Get Profile (Protected)', '/auth/profile', 'GET', null, authToken ? 200 : 401, authHeader);
  
  // 4. PRODUCT ENDPOINTS (7)
  console.log('\n📋 PRODUCT ENDPOINTS\n');
  
  // Get all products (public)
  result = await test('Get All Products (Public)', '/products', 'GET');
  
  // Create product (requires auth)
  result = await test('Create Product (Protected)', '/products', 'POST', {
    name: `Test Product ${Date.now()}`,
    description: 'Test Description',
    price: 99.99,
    quantity: 10,
    status: 'active'
  }, authToken ? 201 : 401, authHeader);
  
  if (result?.data?.id) {
    productId = result.data.id;
    console.log(`   Captured productId: ${productId}`);
  }
  
  // Get user's products (requires auth)
  result = await test('Get My Products (Protected)', '/products/my-products', 'GET', null, authToken ? 200 : 401, authHeader);
  
  // Get product by ID (public)
  if (productId) {
    result = await test('Get Product by ID (Public)', `/products/${productId}`, 'GET');
  }
  
  // Update product (requires auth)
  if (productId) {
    result = await test('Update Product (Protected)', `/products/${productId}`, 'PATCH', {
      name: 'Updated Product Name'
    }, authToken ? 200 : 401, authHeader);
  }
  
  // Delete product (requires auth)
  if (productId) {
    result = await test('Delete Product (Protected)', `/products/${productId}`, 'DELETE', null, authToken ? 200 : 401, authHeader);
  }
  
  // Get product after delete (should fail)
  if (productId) {
    result = await test('Get Deleted Product (Should 404)', `/products/${productId}`, 'GET', null, 404);
  }
  
  // Print summary
  console.log('\n========== TEST SUMMARY ==========\n');
  console.log(`Total: ${testResults.endpoints.length} endpoints`);
  console.log(`✅ Passed: ${testResults.passed}`);
  console.log(`❌ Failed: ${testResults.failed}`);
  
  console.log('\nEndpoint Details:');
  testResults.endpoints.forEach((ep, i) => {
    const sym = ep.success ? '✅' : '❌';
    console.log(`${i+1}. ${sym} ${ep.method} ${ep.path} (${ep.status})`);
  });
  
  console.log('\n===================================\n');
  
  process.exit(testResults.failed > 0 ? 1 : 0);
}

// Wait for server startup
setTimeout(runAllTests, 2000);
