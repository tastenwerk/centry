<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>centry > admin</title>

  {% if env == 'production' %}
    <link rel="stylesheet" href="/css/application.min.css">
  {% else %}
    {% for style in assets.styles %}
      <link rel="stylesheet" href="/assets{{style}}">
    {% endfor %}
  {% endif %}
  
</head>
<body>
  {% for style in assets.styles %}
    <link rel="stylesheet" href="/assets{{style}}">
  {% endfor %}

</body>
</html>