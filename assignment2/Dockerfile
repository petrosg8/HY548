FROM nginx:1.27.4-alpine

RUN apk update && apk add --no-cache wget

ENV SITE_URL=http://example.com

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

# Set the entrypoint to run our script
ENTRYPOINT ["/entrypoint.sh"]
