// Custom command to login
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/users/sign_in')
  cy.get('input[name="user[email]"]').type(email)
  cy.get('input[name="user[password]"]').type(password)
  cy.get('input[type="submit"]').click()
  cy.wait(1000)
})

// Custom command to logout
Cypress.Commands.add('logout', () => {
  cy.get('.dropdown-toggle').click()
  cy.get('a[href="/users/sign_out"]').click()
})

// Custom command to add product to cart
Cypress.Commands.add('addToCart', (productId) => {
  cy.visit(`/products/${productId}`)
  cy.get('input[type="submit"]').contains('Add to Cart').click()
  cy.wait(500)
})

// Custom command to clear cart
Cypress.Commands.add('clearCart', () => {
  cy.visit('/cart')
  cy.get('body').then(($body) => {
    if ($body.find('a[data-turbo-method="delete"]').length > 0) {
      cy.get('a[data-turbo-method="delete"]').contains('Clear Cart').click()
      cy.wait(500)
    }
  })
})
