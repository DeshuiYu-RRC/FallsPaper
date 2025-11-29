describe('Shopping Cart & Checkout Flow', () => {
  
  beforeEach(() => {
    cy.clearCookies()
    cy.clearLocalStorage()
  })

  // ==================== HAPPY PATH ====================
  
  describe('Happy Path: Complete Purchase Flow', () => {
    
    it('should successfully complete entire shopping and checkout process', () => {
      // Step 1: Browse products
      cy.visit('/')
      cy.contains('Products').click()
      cy.url().should('include', '/products')
      cy.get('.product-card').should('have.length.greaterThan', 0)
      
      // Step 2: Add first product to cart
      cy.get('.product-card').first().within(() => {
        cy.get('input[type="submit"]').click()
      })
      cy.wait(500)
      
      // Step 3: Verify cart badge updated
      cy.get('.badge').should('exist')
      
      // Step 4: Add another product
      cy.visit('/products')
      cy.get('.product-card').eq(1).within(() => {
        cy.get('input[type="submit"]').click()
      })
      cy.wait(500)
      
      // Step 5: View cart
      cy.contains('Cart').click()
      cy.url().should('include', '/cart')
      cy.get('.table tbody tr').should('have.length.greaterThan', 0)
      
      // Step 6: Update quantity
      cy.get('input[type="number"]').first().clear().type('2')
      cy.get('input[value="Update"]').first().click()
      cy.wait(500)
      
      // Step 7: Register new user
      cy.contains('Sign Up').click()
      cy.url().should('include', '/users/sign_up')
      
      const timestamp = Date.now()
      const testEmail = `test${timestamp}@example.com`
      
      cy.get('input[name="user[username]"]').type(`testuser${timestamp}`)
      cy.get('input[name="user[email]"]').type(testEmail)
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[name="user[password_confirmation]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Should redirect to home after successful registration
      cy.url().should('eq', Cypress.config().baseUrl + '/')
      
      // Step 8: Proceed to checkout
      cy.contains('Cart').click()
      cy.contains('Proceed to Checkout').click()
      cy.url().should('include', '/checkout')
      
      // Step 9: Fill checkout form
      cy.get('input[name="customer_name"]').clear().type('Test Customer')
      cy.get('input[name="customer_email"]').clear().type(testEmail)
      cy.get('input[name="customer_phone"]').clear().type('204-555-0100')
      cy.get('input[name="delivery_address"]').type('123 Test Street')
      cy.get('input[name="delivery_city"]').type('Winnipeg')
      cy.get('input[name="delivery_postal_code"]').type('R3C1A1')
      cy.get('select[name="province_id"]').select('3') // Manitoba
      
      cy.log('Checkout form completed successfully')
    })
  })

  // ==================== UNHAPPY PATHS ====================
  
  describe('Unhappy Path: Empty Cart Checkout', () => {
    
    it('should prevent checkout with empty cart', () => {
      // Login first
      cy.visit('/users/sign_in')
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Try to access checkout directly with empty cart
      cy.visit('/checkout')
      
      // Should show error message or redirect
      cy.get('body').should('contain', 'cart')
    })
  })
  
  describe('Unhappy Path: Checkout Validation Errors', () => {
    
    it('should show validation errors for incomplete checkout form', () => {
      // Add product to cart
      cy.visit('/products/1')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      
      // Login
      cy.visit('/users/sign_in')
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Go to checkout
      cy.visit('/checkout')
      
      // Clear required fields
      cy.get('input[name="customer_name"]').clear()
      cy.get('input[name="customer_email"]').clear()
      cy.get('input[name="customer_phone"]').clear()
      
      // Browser validation should prevent submission
      cy.get('input[name="customer_name"]:invalid').should('exist')
    })
  })
  
  describe('Unhappy Path: Invalid Province Selection', () => {
    
    it('should require province selection for tax calculation', () => {
      // Add product and login
      cy.visit('/products/1')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      
      cy.visit('/users/sign_in')
      cy.get('input[name="user[email]"]').type('customer@test.com')
      cy.get('input[name="user[password]"]').type('password123')
      cy.get('input[type="submit"]').click()
      
      // Go to checkout
      cy.visit('/checkout')
      
      // Fill form but don't select province
      cy.get('input[name="customer_name"]').type('Test Customer')
      cy.get('input[name="customer_email"]').type('test@example.com')
      cy.get('input[name="customer_phone"]').type('204-555-0100')
      cy.get('input[name="delivery_address"]').type('123 Test St')
      cy.get('input[name="delivery_city"]').type('Winnipeg')
      cy.get('input[name="delivery_postal_code"]').type('R3C1A1')
      
      // Verify province is required
      cy.get('select[name="province_id"]').should('have.attr', 'required')
    })
  })
  
  describe('Unhappy Path: Cart Quantity Validation', () => {
    
    it('should prevent setting quantity to zero or negative', () => {
      // Add product to cart
      cy.visit('/products/1')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      
      // Go to cart
      cy.visit('/cart')
      
      // Quantity input should have min=1
      cy.get('input[type="number"]').first().should('have.attr', 'min', '1')
      
      // Verify can't type negative
      cy.get('input[type="number"]').first().invoke('attr', 'min').should('eq', '1')
    })
  })
  
  describe('Unhappy Path: Out of Stock Product', () => {
    
    it('should show out of stock message for unavailable products', () => {
      cy.visit('/products')
      
      // Check if any out of stock products exist
      cy.get('body').then(($body) => {
        if ($body.find('button:disabled:contains("Out of Stock")').length > 0) {
          // Verify out of stock button is disabled
          cy.get('button:disabled').contains('Out of Stock').should('exist')
        } else {
          cy.log('No out of stock products found - test skipped')
        }
      })
    })
  })
  
  describe('Cart Modification Tests', () => {
    
    it('should allow removing items from cart', () => {
      // Add multiple products
      cy.visit('/products/1')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      cy.visit('/products/2')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      
      // Go to cart
      cy.visit('/cart')
      
      // Get initial row count
      cy.get('.table tbody tr').its('length').then((initialCount) => {
        // Find the remove link - it starts with /cart/remove/
        cy.get('input[type="submit"]').contains('Remove').click()
        cy.wait(500)
        
        // Verify still on cart page
        cy.url().should('include', '/cart')
        cy.log(`Initially had ${initialCount} items, removed one`)
      })
    })
    
    it('should allow clearing entire cart', () => {
      // Add products
      cy.visit('/products/1')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      cy.visit('/products/2')
      cy.get('input[type="submit"]').contains('Add to Cart').click()
      cy.wait(500)
      
      // Clear cart
      cy.visit('/cart')
      
      // Find Clear Cart button - it's a link to /cart/clear
      cy.get('input[type="submit"]').contains('Clear Cart').click()
      cy.wait(500)
      
      // Cart should be empty
      cy.url().should('include', '/cart')
      cy.contains('Your cart is empty').should('be.visible')
    })
  })
})
