import os, sys, json, urllib.request, urllib.error

def main():
    work_dir = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('TEMP', os.environ.get('TMP', '.'))
    if not os.path.isdir(work_dir):
        try:
            os.makedirs(work_dir, exist_ok=True)
        except:
            work_dir = os.environ.get('TEMP', '.')
    base_url = os.environ.get('AI_BASE', '')
    model = os.environ.get('AI_MODEL', '')
    api_key = os.environ.get('AI_KEY', '')
    action = os.environ.get('AI_ACTION', 'chat')

    if action == 'connect':
        do_connect(work_dir, base_url, api_key)
    else:
        do_chat(work_dir, base_url, model, api_key)

def do_connect(tmp, base_url, api_key):
    url = base_url.rstrip('/') + '/models'
    req = urllib.request.Request(url)
    req.add_header('Authorization', 'Bearer ' + api_key)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            result = json.loads(resp.read().decode('utf-8'))
        models = []
        if 'data' in result:
            for m in result['data']:
                mid = m.get('id', '')
                if mid:
                    models.append(mid)
        with open(os.path.join(tmp, 'ai_conn_result.txt'), 'w', encoding='utf-8') as f:
            f.write('OK\n')
            f.write('\n'.join(models) + '\n')
    except urllib.error.HTTPError as e:
        body = e.read().decode('utf-8', errors='replace')
        if e.code == 402 or 'insufficient' in body.lower() or 'quota' in body.lower() or '余额' in body:
            with open(os.path.join(tmp, 'ai_conn_result.txt'), 'w', encoding='utf-8') as f:
                f.write('FAIL\n')
                f.write('账户余额不足，请前往官方平台充值续费后再试。\n')
        elif e.code == 401:
            with open(os.path.join(tmp, 'ai_conn_result.txt'), 'w', encoding='utf-8') as f:
                f.write('FAIL\n')
                f.write('API Key 无效，请检查密钥是否正确。\n')
        else:
            try:
                err_msg = json.loads(body).get('error', {}).get('message', body)
            except:
                err_msg = body
            with open(os.path.join(tmp, 'ai_conn_result.txt'), 'w', encoding='utf-8') as f:
                f.write('FAIL\n')
                f.write(err_msg + '\n')
    except Exception as e:
        with open(os.path.join(tmp, 'ai_conn_result.txt'), 'w', encoding='utf-8') as f:
            f.write('FAIL\n')
            f.write(str(e) + '\n')

def do_chat(tmp, base_url, model, api_key):
    reply_path = os.path.join(tmp, 'ai_reply.txt')
    hist_path = os.path.join(tmp, 'ai_history.json')
    input_path = os.path.join(tmp, 'ai_user_input.txt')

    try:
        with open(input_path, 'r', encoding='utf-8') as f:
            user_msg = f.read().strip()
    except:
        with open(reply_path, 'w', encoding='utf-8') as f:
            f.write('[错误] 无法读取输入\n')
        return
    if not user_msg:
        with open(reply_path, 'w', encoding='utf-8') as f:
            f.write('[错误] 输入为空\n')
        return

    try:
        with open(hist_path, 'r', encoding='utf-8') as f:
            messages = json.load(f)
    except:
        messages = []

    messages.append({"role": "user", "content": user_msg})

    req_data = json.dumps({
        "model": model,
        "messages": messages,
        "temperature": 0.7,
        "stream": False
    }).encode('utf-8')

    url = base_url.rstrip('/') + '/chat/completions'
    req = urllib.request.Request(url, data=req_data, method='POST')
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', 'Bearer ' + api_key)

    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        body = e.read().decode('utf-8', errors='replace')
        if e.code == 402 or 'insufficient' in body.lower() or 'quota' in body.lower() or '余额' in body:
            with open(reply_path, 'w', encoding='utf-8') as f:
                f.write('[余额不足] 账户余额不足，请前往官方平台充值续费后再试。\n')
            return
        if e.code == 401:
            with open(reply_path, 'w', encoding='utf-8') as f:
                f.write('[认证失败] API Key 无效，请检查密钥是否正确。\n')
            return
        if e.code == 429:
            with open(reply_path, 'w', encoding='utf-8') as f:
                f.write('[请求过频] 请求过于频繁，请稍后再试。\n')
            return
        try:
            msg = json.loads(body).get('error', {}).get('message', body)
        except:
            msg = body
        with open(reply_path, 'w', encoding='utf-8') as f:
            f.write('[API错误] ' + msg + '\n')
        return
    except Exception as e:
        with open(reply_path, 'w', encoding='utf-8') as f:
            f.write('[网络错误] ' + str(e) + '\n')
        return

    try:
        reply = result['choices'][0]['message']['content']
    except:
        with open(reply_path, 'w', encoding='utf-8') as f:
            f.write('[解析错误] 无法解析API响应\n')
        return

    with open(reply_path, 'w', encoding='utf-8') as f:
        f.write(reply + '\n')

    messages.append({"role": "assistant", "content": reply})
    with open(hist_path, 'w', encoding='utf-8') as f:
        json.dump(messages, f, ensure_ascii=False)

if __name__ == '__main__':
    main()
