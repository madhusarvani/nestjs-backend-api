# Contributing Guidelines

Thank you for your interest in contributing to this NestJS Backend API project!

## Code Standards

### TypeScript
- Use strict mode
- Add explicit type annotations
- Avoid `any` type
- Use interfaces/types for data structures

### Naming Conventions
- **Classes**: PascalCase (e.g., `UserService`)
- **Methods/Functions**: camelCase (e.g., `createUser`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_FILE_SIZE`)
- **Files**: kebab-case (e.g., `user.service.ts`)

### Code Organization
```
src/
├── [feature]/
│   ├── [feature].controller.ts
│   ├── [feature].service.ts
│   ├── [feature].module.ts
│   ├── entities/
│   │   └── [feature].entity.ts
│   ├── dto/
│   │   ├── create-[feature].dto.ts
│   │   └── update-[feature].dto.ts
│   └── test/
│       └── [feature].service.spec.ts
```

## Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/add-users-filter
   ```

2. **Follow NestJS Best Practices**
   - Use services for business logic
   - Use controllers for HTTP handling
   - Use DTOs for validation
   - Use guards for authentication
   - Use interceptors for cross-cutting concerns

3. **Write Tests**
   ```bash
   npm test -- feature.service.spec.ts
   ```

4. **Commit Messages**
   ```
   feat: Add user filtering to products list
   fix: Resolve JWT token validation issue
   docs: Update API documentation
   test: Add test for product creation
   ```

5. **Submit Pull Request**
   - Clear description of changes
   - Link related issues
   - Ensure all tests pass
   - Update documentation

## Quality Checklist

Before submitting, ensure:
- ✅ Code follows TypeScript strict mode
- ✅ DTOs have proper validation
- ✅ Services have proper error handling
- ✅ Tests are written and passing
- ✅ No console.logs left in code
- ✅ Documentation is updated
- ✅ No hardcoded values/secrets
- ✅ HTTPS/CORS properly configured

## Testing Requirements

- Unit tests for services
- Integration tests for controllers
- 80%+ code coverage goal
- All edge cases covered

Example:
```typescript
describe('UserService', () => {
  let service: UserService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [UserService],
    }).compile();
    service = module.get<UserService>(UserService);
  });

  it('should create user', async () => {
    const result = await service.create({
      email: 'test@example.com',
      fullName: 'Test User',
      password: 'password123',
      phoneNumber: '+1-555-0000',
    });
    expect(result).toHaveProperty('id');
  });
});
```

## Performance Considerations

- Use database indexes
- Lazy-load relationships
- Implement pagination
- Cache frequently accessed data
- Avoid N+1 queries

## Security Requirements

- No hardcoded secrets
- Hash passwords (bcrypt)
- Validate all inputs
- Use environment variables
- Implement rate limiting
- Add CORS headers
- Use HTTPS in production

## Documentation

Update:
- README.md for major changes
- Code comments for complex logic
- API documentation
- Environment variables in .env.example

## Questions?

Open an issue on GitHub or create a discussion.

## Code Review Process

1. Automated tests must pass
2. Code review by maintainer
3. Approval before merge
4. Merge to master
5. Tag release version

## Release Process

```bash
npm version patch  # v1.0.1
npm version minor  # v1.1.0
npm version major  # v2.0.0
git push origin master --tags
npm publish
```

Thank you for contributing! 🎉
