import styled from 'styled-components';

const Container = styled.div`
  width: 60%;
  display: flex;
  margin: 0 auto;
  margin-top: 30px;
`;

const Image = styled.div`
  background-image: url(${(props) => props.image});
  background-size: cover;
  border-radius: 10px;
  display: block;
  width: 30px;
  height: 30px;
  margin: 10px;
`;

const CommentContainer = styled.div`
  width: 65%;
  height: 230px;
  display: flex;
  padding-right: 20px;
`;

export { Container, CommentContainer, Image };
