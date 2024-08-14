# alpine 3.19 버전의 리눅스를 구축하는데, 파이썬 버전은 3.11로 설치된 이미지를 불러줘
# apline - 경량화된 리눅스 버전 => 가볍다 => 왜 좋은가?
# => 빌드가 계속 반복이 되는데, 이미지 자체가 무거우면 빌드 속도가 느려집니다.
FROM python:3.11-alpine3.19

LABEL maintainer='j'

# python 0:1 = False:True
# 컨테이너에 찍히는 로그를 볼 수 있도록 허용한다.
# 도커 컨테이너에서 어떤 일이 벌어지고 있는지 알아야지 디버깅을 하겠죠?
# 실시간으로 볼 수 있기 때문에 컨테이너 관리가 편해집니다.
ENV PYTHONUNBUFFERED 1

# tmp 폴더 나중에 빌드가 완료되면 삭제합니다. 컨테이너 경량 상태 유지 위해

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
USER django-user

# Django(Scikit-learn => REST API) - Docker - Github Actions(CI/CD)
# 내일 ML flow => ML ops