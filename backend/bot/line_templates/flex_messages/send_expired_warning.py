def send_expired_warning(remaining_date: int):
    template = {
        "type": "bubble",
        "size": "kilo",
        "direction": "ltr",
        "hero": {
            "type": "image",
            "url": "https://cdn-icons-png.flaticon.com/512/9097/9097999.png",
            "align": "center",
            "size": "full",
            "aspectRatio": "3:1",
            "aspectMode": "fit",
            "offsetTop": "20px"
        },
        "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
                {
                    "type": "text",
                    "text": "ระยะเวลาสมาชิกของคุณหมดแล้ว ต้องการต่ออายุไหมครับ ?",
                    "align": "center",
                    "margin": "xxl",
                    "wrap": True,
                    "contents": []
                }
            ]
        },
        "footer": {
            "type": "box",
            "layout": "vertical",
            "contents": [
                {
                    "type": "button",
                    "action": {
                        "type": "uri",
                        "label": "ต้องการ",
                        "uri": "https://kalive.knightarmyacademy.com/pricing"
                    },
                    # "color": "#000000"
                }
            ]
        }
    }
    return template
