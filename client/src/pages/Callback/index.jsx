/* eslint-disable react/prop-types */
import React, { useEffect, useContext } from 'react';
// eslint-disable-next-line import/no-extraneous-dependencies
import qs from 'qs';
import { UserContext } from '../../stores/userStore';

const Callback = ({ history, location }) => {
  const {
    userAction: { loginUser },
  } = useContext(UserContext);

  useEffect(async () => {
    const { code } = qs.parse(location.search, {
      ignoreQueryPrefix: true,
    });
    await loginUser(code);
    return history.push('/');
  }, []);

  return <div>hello</div>;
};

export default Callback;
