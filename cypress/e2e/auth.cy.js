describe('User Authentication', () => {
  
  beforeEach(() => {
    cy.clearCookies()
    cy.clearLocalStorage()
  })

  // ==================== SIGN UP HAPPY PATH ====================
  
  describe('Happy Path: User Registration', () => {
    
    it('should successfully register a new user', () => {
      cy.visit('/')
      cy.contains('Sign Up').click()
      cy.url().should('include', '/users/sign_up')
      
      const timestamp = Date.now()
      const username = `testuser${timestamp}`
      const email = `test${timestamp}@example.com`
      
      cy.get('input[name="user[username]"]').type(username)
      cy.get('input[name="user[email]"]').type(email)
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[name="user[password_confirmation]"]').type('password123')
      
      cy.get('input[type="submit"]').click()
      
      // Should redirect and show success message
      cy.url().should('eq', Cypress.config().baseUrl + '/')
      cy.contains('Welcome! You have signed up successfully').should('be.visible')
      
      // Should show username in navigation dropdown
      cy.get('.dropdown-toggle').should('contain', username)
    })
  })

  // ==================== SIGN UP UNHAPPY PATHS ====================
  
  describe('Unhappy Path: Registration with Existing Email', () => {
    
    it('should show error when registering with existing email', () => {
      cy.visit('/users/sign_up')
      
      // Try to register with existing email
      cy.get('input[name="user[username]"]').type('newuser')
      cy.get('input[name="user[email]"]').type('customer@test.com') // Existing email
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[name="user[password_confirmation]"]').type('password123')
      
      cy.get('input[type="submit"]').click()
      
      // Should show error message
      cy.contains('Email has already been taken').should('be.visible')
    })
  })
  
  describe('Unhappy Path: Password Mismatch', () => {
    
    it('should show error when passwords do not match', () => {
      cy.visit('/users/sign_up')
      
      const timestamp = Date.now()
      
      cy.get('input[name="user[username]"]').type(`user${timestamp}`)
      cy.get('input[name="user[email]"]').type(`test${timestamp}@example.com`)
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[name="user[password_confirmation]"]').type('differentpassword')
      
      cy.get('input[type="submit"]').click()
      
      // Should show error
      cy.contains("Password confirmation doesn't match").should('be.visible')
    })
  })
  
  describe('Unhappy Path: Short Password', () => {
    
    it('should show error for password less than 6 characters', () => {
      cy.visit('/users/sign_up')
      
      const timestamp = Date.now()
      
      cy.get('input[name="user[username]"]').type(`user${timestamp}`)
      cy.get('input[name="user[email]"]').type(`test${timestamp}@example.com`)
      cy.get('input[name="user[password]"]').type('123')
      cy.get('input[name="user[password_confirmation]"]').type('123')
      
      cy.get('input[type="submit"]').click()
      
      // Should show error
      cy.contains('Password is too short').should('be.visible')
    })
  })

  // ==================== LOGIN HAPPY PATH ====================
  
  describe('Happy Path: User Login', () => {
    
    it('should successfully login with correct credentials', () => {
      cy.visit('/')
      cy.contains('Login').click()
      cy.url().should('include', '/users/sign_in')
      
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Should redirect and show success
      cy.url().should('eq', Cypress.config().baseUrl + '/')
      cy.contains('Signed in successfully').should('be.visible')
      
      // Should show customer username in dropdown
      cy.get('.dropdown-toggle').should('exist')
    })
  })

  // ==================== LOGIN UNHAPPY PATHS ====================
  
  describe('Unhappy Path: Login with Incorrect Password', () => {
    
    it('should show error with wrong password', () => {
      cy.visit('/users/sign_in')
      
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('wrongpassword')
      cy.get('input[type="submit"]').click()
      
      // Should show error
      cy.contains('Invalid Email or password').should('be.visible')
      
      // Should stay on login page
      cy.url().should('include', '/users/sign_in')
    })
  })
  
  describe('Unhappy Path: Login with Non-existent Email', () => {
    
    it('should show error for non-existent email', () => {
      cy.visit('/users/sign_in')
      
      cy.get('input[name="user[email]"]').type('nonexistent@example.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Should show error
      cy.contains('Invalid Email or password').should('be.visible')
    })
  })
  
  describe('Unhappy Path: Empty Login Form', () => {
    
    it('should prevent submission with empty fields', () => {
      cy.visit('/users/sign_in')
      
      cy.get('input[type="submit"]').click()
      
      // Browser validation should prevent submission
      cy.get('input[name="user[email]"]:invalid').should('exist')
    })
  })
  
  // ==================== LOGOUT ====================
  
  describe('User Logout', () => {
    
    it('should successfully logout', () => {
      // Login first
      cy.visit('/users/sign_in')
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Verify logged in
      cy.get('.dropdown-toggle').should('exist')
      
      // Open dropdown and logout
      cy.get('.dropdown-toggle').click()
      cy.get('a[href="/users/sign_out"]').click()
      
      // Should show success message
      cy.contains('Signed out successfully').should('be.visible')
      
      // Should show Login link again
      cy.contains('Login').should('be.visible')
    })
  })
})
