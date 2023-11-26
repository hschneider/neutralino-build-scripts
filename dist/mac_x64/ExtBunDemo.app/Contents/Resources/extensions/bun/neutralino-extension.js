// NeutralinoExtension
//
// A Bun extension engine for Neutralino.
//
// (c)2023 Harald Schneider

class NeutralinoExtension {
    constructor(debug=false) {
        this.version = '1.0.0';

        this.debug = debug;
        this.debugTermColors = true;             // Use terminal colors
        this.debugTermColorIN = '\x1b[32m';      // Green: All incoming events, except function calls
        this.debugTermColorCALL = '\x1b[91m';    // Red: Incoming function calls
        this.debugTermColorOUT = '\x1b[33m';     // Yellow: Outgoing events

        this.port = Bun.argv[2].split('=')[1];
        this.token = Bun.argv[3].split('=')[1];
        this.idExtension = Bun.argv[4].split('=')[1];

        this.urlSocket = `ws://127.0.0.1:${this.port}?extensionId=${this.idExtension}`;
        this.socket = undefined;

        this.termOnWindowClose = true;   // Terminate on windowCloseEvent message

        this.debugLog(`${this.idExtension} running on port ${this.port}`);
    }

    sendMessage(event, data=null) {
        //
        // Add a data package to the sending queue.
        // Triggers an event in the parent app.
        // :param event: Event name as string
        // :param data: Event data
        // :return: --

        let d = {
            "id": crypto.randomUUID(),
            "method": 'app.broadcast',
            "accessToken": this.token,
            "data": {
                "event": event,
                "data": data
            }
        }
        if (this.socket.readyState === WebSocket.OPEN) {
            let msg = JSON.stringify(d);
            this.socket.send(msg);
            this.debugLog(`${msg}`, 'out');
        } else {
            console.warn("WebSocket send: Socket is not connected.");
        }
    }

    run(onReceiveMessage) {
        //
        //  Socket-handler main loop. Sends and receives messages.
        //  :param onReceiveMessage: Callback for incoming messages

        const WebSocket = require('ws');
        this.socket = new WebSocket(this.urlSocket);
        let self = this;

        this.socket.on('open', () => {
            console.log('WebSocket ready');
            console.log(`Running on port ${self.port}`);
        });

        this.socket.on('message', (data) => {
            let msg = data.toString('utf-8');

            try {
                msg = JSON.parse(msg);
            }
            catch (e) {}

            try {
                if(self.termOnWindowClose) {
                    if(d.event === 'windowClose' || d.event === 'appClose') {
                        // ToDo: Implement SIGTERM ?
                        // Looks like the current Bun release quits properly.
                        return;
                    }
                }
            }
            catch (e) {}

            self.debugLog(msg, 'in');
            onReceiveMessage(msg);
        });

        this.socket.on('close', (code, reason) => {
            console.log(`WebSocket closed: ${code} - ${reason}`);
        });

        this.socket.on('error', (error) => {
            console.error(`WebSocket Error: ${error}`);
        });
    }

    debugLog(msg, tag='info') {
        //
        // Log messages to terminal.
        // :param msg: Message string
        // :param tag: Type of log entry
        // :return: --

        let cIN = '';
        let cCALL = '';
        let cOUT = '';
        let cRST = '';

        if(this.debugTermColors) {
            cIN = this.debugTermColorIN;
            cCALL = this.debugTermColorCALL;
            cOUT = this.debugTermColorOUT;
            cRST = '\x1b[0m';
        }

        if(!this.debug) {
            return;
        }

        try {
            msg = JSON.stringify(msg);
        }
        catch (e) {}

        if(tag === 'in') {
            if(msg.includes('runBun')) {
                console.log(`${cCALL}IN:  ${msg}${cRST}`);
            }
            else {
                console.log(`${cIN}IN:  ${msg}${cRST}`);
            }
            return;
        }
        if(tag === 'out') {
            console.log(`${cOUT}OUT: ${msg}${cRST}`);
            return;
        }
        //console.log(msg);
    }
}

module.exports = NeutralinoExtension;