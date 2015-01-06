Centry.AccountsShowView = Centry.FadedView.extend
  layoutName: 'accounts/layout'

Centry.AccountsMineView = Centry.AccountsShowView.extend
  templateName: 'accounts/show'
  layoutName: 'accounts/layout'
