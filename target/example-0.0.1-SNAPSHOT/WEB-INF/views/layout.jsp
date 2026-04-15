<!-- Inclusion de la navigation -->
    <%@ include file="includes/header.jsp" %>

<!-- Main Content -->
    <main class="container">
        <div class="row">
            <div class="col-12">
                <!-- Include Content Page -->
                <%
                    String contentPage = (String) request.getAttribute("content");
                    if (contentPage != null && !contentPage.isEmpty()) {
                %>
                <jsp:include page="<%= contentPage %>" />
                <% } else { %>
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle"></i> Aucun contenu spécifié.
                </div>
                <% } %>
            </div>
        </div>
    </main>

<!-- Footer -->
    <jsp:include page="includes/footer.jsp" />

