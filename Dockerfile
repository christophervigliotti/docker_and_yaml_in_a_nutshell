# Assignment 1
FROM alpine
ARG USERNAME
ENV USERNAME ${USERNAME}
CMD echo "Yup, your name is '${USERNAME}'... or at least that's what you told me."

# Lesson 2
# FROM alpine
# CMD echo "hello world"
