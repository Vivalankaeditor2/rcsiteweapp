# Testing Rules
- Test classes must use the same package structure as the class under test.
- Test class naming: `[ClassName]Test.java`.
- Use `@ExtendWith(MockitoExtension.class)` for unit tests.
- Use `@WebMvcTest` for controller tests; mock all dependencies with `@MockBean`.
- Follow the AAA pattern, commenting each section:
  ```
  // Arrange
  // Act
  // Assert
  ```
- Test names: `should_[expected]_when_[condition]`.
- One assertion block per test.
- Use Mockito for mocking and verification.
- Use MockMvc for controller/API tests.
- Continue using JUnit assertions such as `assertEquals`, `assertTrue`, `assertFalse`, `assertNotNull`, and `assertThrows`.
- Never test private methods.
