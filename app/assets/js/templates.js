Ember.TEMPLATES["application"] = Ember.Handlebars.template({"1":function(depth0,helpers,partials,data) {
  data.buffer.push("<h1>you are logged in</h1>\n");
  },"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var stack1, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, buffer = '';
  stack1 = helpers['if'].call(depth0, "authenticated", {"name":"if","hash":{},"hashTypes":{},"hashContexts":{},"fn":this.program(1, data),"inverse":this.noop,"types":["ID"],"contexts":[depth0],"data":data});
  if (stack1 != null) { data.buffer.push(stack1); }
  data.buffer.push("\n");
  stack1 = helpers._triageMustache.call(depth0, "outlet", {"name":"_triageMustache","hash":{},"hashTypes":{},"hashContexts":{},"types":["ID"],"contexts":[depth0],"data":data});
  if (stack1 != null) { data.buffer.push(stack1); }
  data.buffer.push("\n\n");
  data.buffer.push(escapeExpression(((helpers.outlet || (depth0 && depth0.outlet) || helperMissing).call(depth0, "modal", {"name":"outlet","hash":{},"hashTypes":{},"hashContexts":{},"types":["STRING"],"contexts":[depth0],"data":data}))));
  return buffer;
},"useData":true});

Ember.TEMPLATES["sessions/login"] = Ember.Handlebars.template({"1":function(depth0,helpers,partials,data) {
  var escapeExpression=this.escapeExpression, buffer = '';
  data.buffer.push("    <div ");
  data.buffer.push(escapeExpression(helpers['bind-attr'].call(depth0, {"name":"bind-attr","hash":{
    'class': (":alert valid:alert-info:alert-danger error:alert-danger")
  },"hashTypes":{'class': "STRING"},"hashContexts":{'class': depth0},"types":[],"contexts":[],"data":data})));
  data.buffer.push(">");
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "message", {"name":"_triageMustache","hash":{
    'unescaped': ("true")
  },"hashTypes":{'unescaped': "STRING"},"hashContexts":{'unescaped': depth0},"types":["ID"],"contexts":[depth0],"data":data})));
  data.buffer.push("</div>\n");
  return buffer;
},"3":function(depth0,helpers,partials,data) {
  var helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression;
  data.buffer.push(escapeExpression(((helpers.t || (depth0 && depth0.t) || helperMissing).call(depth0, "forgot_your_password", {"name":"t","hash":{},"hashTypes":{},"hashContexts":{},"types":["STRING"],"contexts":[depth0],"data":data}))));
  },"compiler":[6,">= 2.0.0-beta.1"],"main":function(depth0,helpers,partials,data) {
  var stack1, escapeExpression=this.escapeExpression, helperMissing=helpers.helperMissing, buffer = '';
  data.buffer.push("<div class=\"login-wrap\">\n\n  <form ");
  data.buffer.push(escapeExpression(helpers.action.call(depth0, "loginUser", {"name":"action","hash":{
    'on': ("submit")
  },"hashTypes":{'on': "STRING"},"hashContexts":{'on': depth0},"types":["STRING"],"contexts":[depth0],"data":data})));
  data.buffer.push(" class=\"card\">\n    <input type=\"submit\" class=\"hide\">\n\n");
  stack1 = helpers['if'].call(depth0, "message", {"name":"if","hash":{},"hashTypes":{},"hashContexts":{},"fn":this.program(1, data),"inverse":this.noop,"types":["ID"],"contexts":[depth0],"data":data});
  if (stack1 != null) { data.buffer.push(stack1); }
  data.buffer.push("\n    <div class=\"logo\">\n      <i class=\"mdi-image-filter-vintage\"></i> centry login\n    </div>\n\n    <div class=\"login-form-group\">\n      <i class=\"mdi-content-email\"></i>\n      ");
  data.buffer.push(escapeExpression(((helpers.input || (depth0 && depth0.input) || helperMissing).call(depth0, {"name":"input","hash":{
    'placeholderTranslation': ("username_or_email"),
    'value': ("login")
  },"hashTypes":{'placeholderTranslation': "STRING",'value': "ID"},"hashContexts":{'placeholderTranslation': depth0,'value': depth0},"types":[],"contexts":[],"data":data}))));
  data.buffer.push("\n    </div>\n\n    <div class=\"form-group\">\n      ");
  data.buffer.push(escapeExpression(((helpers.input || (depth0 && depth0.input) || helperMissing).call(depth0, {"name":"input","hash":{
    'placeholderTranslation': ("password"),
    'value': ("password"),
    'class': ("form-control"),
    'type': ("password")
  },"hashTypes":{'placeholderTranslation': "STRING",'value': "ID",'class': "STRING",'type': "STRING"},"hashContexts":{'placeholderTranslation': depth0,'value': depth0,'class': depth0,'type': depth0},"types":[],"contexts":[],"data":data}))));
  data.buffer.push("\n    </div>\n\n    <div class=\"form-group\">\n      <input type=\"submit\" class=\"btn btn-primary form-control\" ");
  data.buffer.push(escapeExpression(((helpers.translateAttr || (depth0 && depth0.translateAttr) || helperMissing).call(depth0, {"name":"translateAttr","hash":{
    'value': ("login")
  },"hashTypes":{'value': "STRING"},"hashContexts":{'value': depth0},"types":[],"contexts":[],"data":data}))));
  data.buffer.push(">\n    </div>\n\n    <div class=\"form-group center\">\n      ");
  stack1 = ((helpers['link-to'] || (depth0 && depth0['link-to']) || helperMissing).call(depth0, "sessions.forgot_password", {"name":"link-to","hash":{},"hashTypes":{},"hashContexts":{},"fn":this.program(3, data),"inverse":this.noop,"types":["STRING"],"contexts":[depth0],"data":data}));
  if (stack1 != null) { data.buffer.push(stack1); }
  data.buffer.push("\n    </div>\n\n  </form>\n</div>\n");
  return buffer;
},"useData":true});