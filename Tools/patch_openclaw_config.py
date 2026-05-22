#!/usr/bin/env python3
import json
import os
import sys


def patch_config(workdir):
    path = os.path.join(workdir, '.openclaw_config', 'openclaw.json')
    if not os.path.exists(path):
        print(f"⚠️  설정 파일이 없습니다: {path}")
        return

    try:
        with open(path, 'r') as f:
            config = json.load(f)

        # 1. Tailscale 도메인 및 IP 확보
        # 시스템에 설치된 python3를 사용하거나 현재 실행 중인 인터프리터를 사용
        py_cmd = "python3"
        tailnet_domain = os.popen(f"tailscale status --json | {py_cmd} -c 'import sys, json; print(json.load(sys.stdin).get(\"CertDomains\", [\"\"])[0])'").read().strip()
        ts_ip4 = os.popen("tailscale ip -4").read().strip()
        ts_ip6 = os.popen("tailscale ip -6").read().strip()

        # 2. 보안 패치 (Proxy 신뢰 및 Origin 허용)
        gw = config.setdefault('gateway', {})

        # 신뢰하는 프록시 대역 (로컬, 컨테이너 내부, Tailscale)
        trusted = [
            '127.0.0.1', '::1',
            '100.64.0.0/10',    # Tailscale IPv4
            'fd00::/8',         # Tailscale IPv6
            '172.16.0.0/12',    # Docker bridge 기본
            '10.0.0.0/8',       # 사설 대역
            '192.168.0.0/16'    # 사설 대역
        ]
        for ip in [ts_ip4, ts_ip6]:
            if ip and ip not in trusted:
                trusted.append(ip)
        gw['trustedProxies'] = trusted

        ui = gw.setdefault('controlUi', {})
        origins = ui.setdefault('allowedOrigins', [])

        # 주소 등록 (통합 센터 18789 포트 집중)
        if tailnet_domain:
            t_url = f'https://{tailnet_domain}:18789'
            if t_url not in origins:
                origins.append(t_url)

        for local_url in ['http://localhost:18789', 'http://127.0.0.1:18789']:
            if local_url not in origins:
                origins.append(local_url)

        with open(path, 'w') as f:
            json.dump(config, f, indent=2)

        print(f"✅ OpenClaw 보안 패치 완료 (원본 파일: {path})")
        print(f"   - 신뢰 프록시: {ts_ip4}, {ts_ip6}")

    except Exception as e:
        print(f"❌ 보안 패치 중 오류 발생: {e}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: patch_openclaw_config.py <workdir>")
        sys.exit(1)
    patch_config(sys.argv[1])
