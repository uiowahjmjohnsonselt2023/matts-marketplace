// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// app/javascript/application.js
// app/javascript/application.js
document.addEventListener('turbo:load', function() {
  var showModalButton = document.querySelector('[data-toggle="addModal"]');
  var closeModalButton = document.querySelector('#closeModalButton');
  var modal = document.querySelector('#addBalanceModal');
  var body = document.querySelector('body');
  if (showModalButton && closeModalButton && modal && body) {
    showModalButton.addEventListener('click', function(event) {
      event.preventDefault();
      modal.classList.remove('hidden');
      body.classList.add('modal-open');
    });

    closeModalButton.addEventListener('click', function(event) {
      modal.classList.add('hidden');
      body.classList.remove('modal-open');
    });

    window.addEventListener('click', function(event) {
      if (event.target === modal) {
        modal.classList.add('hidden');
        body.classList.remove('modal-open');
      }
    });
  }

  var showWithdrawModalButton = document.querySelector('[data-toggle="withdrawModal"]');
  var closeWithdrawModalButton = document.querySelector('#closeWithdrawModalButton');
  var withdrawModal = document.querySelector('#withdrawBalanceModal');
  if (showWithdrawModalButton && closeWithdrawModalButton && withdrawModal && body) {
    showWithdrawModalButton.addEventListener('click', function(event) {
      event.preventDefault();
      withdrawModal.classList.remove('hidden');
      body.classList.add('modal-open');
    });

    closeWithdrawModalButton.addEventListener('click', function(event) {
      withdrawModal.classList.add('hidden');
      body.classList.remove('modal-open');
    });

    window.addEventListener('click', function(event) {
      if (event.target === withdrawModal) {
        withdrawModal.classList.add('hidden');
        body.classList.remove('modal-open');
      }
    });
  }
});