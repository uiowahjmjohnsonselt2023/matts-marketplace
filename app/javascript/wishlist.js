// app/javascript/packs/wishlist.js
document.addEventListener('turbolinks:load', function() {
  var starButton = document.getElementById('star-button');
  if (starButton) {
    starButton.addEventListener('ajax:success', function(event) {
      var starIcon = document.getElementById('star-icon');
      if (starIcon.classList.contains('text-gray-400')) {
        starIcon.classList.remove('text-gray-400');
        starIcon.classList.add('text-yellow-500');
      } else {
        starIcon.classList.remove('text-yellow-500');
        starIcon.classList.add('text-gray-400');
      }
    });

    starButton.addEventListener('ajax:error', function(event) {
      alert('There was an error updating the wishlist.');
    });
  }
});