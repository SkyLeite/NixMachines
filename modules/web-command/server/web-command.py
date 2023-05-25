import json
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def main():
    f = open("/etc/web-command.json")
    content = f.read()
    commands = json.loads(content)
    return render_template("index.html", commands=commands)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8001, debug=True)
