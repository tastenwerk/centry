<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>{% block title %}centry{% endblock %}</title>

  {% block head %}
  <link rel="stylesheet" href="/css/application.css">
  {% endblock %}
  
</head>
<body>
  {% block content %}{% endblock %}
</body>
</html>