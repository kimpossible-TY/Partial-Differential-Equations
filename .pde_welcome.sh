clear
echo -e "\n\033[0;32m=====================================================\033[0m"
echo -e "\033[0;32m✨ 서버 구동 완료! Safari 북마크로 바로 열기 가능  \033[0m"
echo -e "   → 📄 PDF 뷰어: \033[0;34mhttps://kimtaeyoungs-macbook-air.tail8adc61.ts.net/main.pdf\033[0m"
echo -e "   → 💬 AI 챗봇(OpenClaw): \033[0;34mhttps://kimtaeyoungs-macbook-air.tail8adc61.ts.net:18789\033[0m"
echo -e "\033[0;32m=====================================================\033[0m"
echo -e "💡 이 창을 닫으면(exit) 세션이 종료되고 모든 서버가 중지됩니다.\n"
if [ -f "/Users/taeyoung/Documents/Department of Defense Typst/Partial Differential Equations/.env" ]; then
    echo -e "💡 .env 파일이 로드되었습니다. (API 키 적용됨)\n"
fi
echo -e "💡 다른 창 보기: Ctrl+B → 숫자(0=typst, 1=http, 2=openclaw, 3=nightwatch)\n"
# exit 시 세션 전체 + 컨테이너 종료
trap 'docker compose -f "/Users/taeyoung/Documents/Department of Defense Typst/Partial Differential Equations/docker-compose.yml" down 2>/dev/null; tmux kill-session -t pde_workspace' EXIT
exec /bin/zsh -l
