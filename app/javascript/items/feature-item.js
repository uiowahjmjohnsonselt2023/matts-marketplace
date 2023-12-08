
document.addEventListener('DOMContentLoaded', function() {
    const featureCheckbox = document.getElementById('featured-checkbox');
    const featuredAmountField = document.getElementById('featured-amount-field');

    // Function to toggle the display of the featured amount field
    function toggleFeaturedAmountField() {
        if (featureCheckbox.checked) {
            featuredAmountField.style.display = 'block';
        } else {
            featuredAmountField.style.display = 'none';
        }
    }

    // Initial check on page load
    toggleFeaturedAmountField();

    // Event listener for checkbox change
    featureCheckbox.addEventListener('change', toggleFeaturedAmountField);
});