// Scripts personnalisés pour l'application visa

$(document).ready(function() {
    // Auto-dismiss des alertes après 5 secondes
    setTimeout(function() {
        $('.alert').alert('close');
    }, 5000);

    // Confirmation pour les actions de suppression
    $('.btn-delete').on('click', function(e) {
        if (!confirm('Êtes-vous sûr de vouloir supprimer cet élément ?')) {
            e.preventDefault();
        }
    });

    // Validation des formulaires
    $('form').on('submit', function() {
        $(this).find(':submit').prop('disabled', true);
        $(this).find(':submit').html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Chargement...');
    });

    // Gestion des dates
    $('.datepicker').datepicker({
        format: 'dd/mm/yyyy',
        language: 'fr',
        autoclose: true,
        todayHighlight: true
    });

    // Mise à jour automatique des prix
    $('select[name="siegeId"], select[name="categorieId"]').on('change', function() {
        updatePrix();
    });

    // Fonction pour mettre à jour le prix
    function updatePrix() {
        // Cette fonction pourrait être implémentée pour calculer
        // le prix en fonction du siège et de la catégorie
    }
});