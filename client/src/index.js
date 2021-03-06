import React from 'react';
import ReactDom from 'react-dom';
import { BrowserRouter } from 'react-router-dom';

import { ThemeProvider } from 'styled-components';
import theme from './style/theme';
import GlobalStyle from './style/global-style';
import App from './App';

import { UserProvider } from './stores/userStore';
import { IssueProvider } from './stores/issueStore';
import { CreateInfoProvider } from './stores/createInfoStore';

ReactDom.render(
  <BrowserRouter>
    <CreateInfoProvider>
      <UserProvider>
        <IssueProvider>
          <ThemeProvider theme={theme}>
            <GlobalStyle />
            <App />
          </ThemeProvider>
        </IssueProvider>
      </UserProvider>
    </CreateInfoProvider>
  </BrowserRouter>,
  document.getElementById('root')
);
