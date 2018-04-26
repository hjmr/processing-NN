int NUMBER_OF_INPUT  = 3;
int NUMBER_OF_HIDDEN = 6;
int NUMBER_OF_OUTPUT = 5;

int TRAINING_CYCLE = 10;

NeuralNet nn = null;
Neuron selected = null;

int trainingSetIdx;
ArrayList trainingSet;
int trainingCount;

float btnR = 20;

PVector runBtnPos;
boolean running = false;

PVector trainBtnPos;
boolean training = false;

PVector memoryBtnPos;
PVector recallBtnPos;

void setup() {
    size(window.innerWidth - 30, window.innerHeight - 130);
    frameRate(20);
    background(0);

    nn = new NeuralNet(NUMBER_OF_INPUT, NUMBER_OF_HIDDEN, NUMBER_OF_OUTPUT);
    nn.randomizeConnection();
    selected = null;

    trainingSetIdx = 0;
    trainingSet = new ArrayList();
    trainingCount = 0;

    runBtnPos   = new PVector(width - 30, 30);
    running = false;

    trainBtnPos = new PVector(width - 30, 80);
    training = false;

    memoryBtnPos = new PVector(width - 30, 150);
    recallBtnPos = new PVector(width - 30, 200);

    nn.getInputNeuronAt(0).setLabel("若い");
    nn.getInputNeuronAt(1).setLabel("かっこいい");
    nn.getInputNeuronAt(2).setLabel("女性");

    nn.getOutputNeuronAt(0).setLabel("山崎賢人");
    nn.getOutputNeuronAt(1).setLabel("渡辺 謙");
    nn.getOutputNeuronAt(2).setLabel("桐谷美玲");
    nn.getOutputNeuronAt(3).setLabel("樹木希林");
    nn.getOutputNeuronAt(4).setLabel("マツコデラックス");
}

void draw() {
    fadeToBlack();

    color runBtnCol = color(0,0,255);
    color trainBtnCol = color(0,0,255);

    if( training == true ) {
        runBtnCol   = color(255,0,0);
        trainBtnCol = color(255,0,0);

        if( trainingSet.size() == 0 ) {
            registerCurrentTrainingSet();
        }

        nn.calculateOutput();
        nn.calculateDelta();
        nn.calculateConnectionUpdate();
        nn.updateConnection();

        trainingCount++;
        if( TRAINING_CYCLE < trainingCount ) {
            selectRandomTrainingSet();
            trainingCount = 0;
        }
    } else if( running == true ) {
        runBtnCol = color(255,0,0);

        nn.calculateOutput();
    }

    noStroke();
    fill(runBtnCol);
    ellipse(runBtnPos.x, runBtnPos.y, btnR * 2, btnR * 2);

    fill(trainBtnCol);
    ellipse(trainBtnPos.x, trainBtnPos.y, btnR * 2, btnR * 2);

    fill(0,255,0);
    rect(memoryBtnPos.x - btnR, memoryBtnPos.y - btnR, btnR * 2, btnR * 2);

    fill(255,255,0);
    rect(recallBtnPos.x - btnR, recallBtnPos.y - btnR, btnR * 2, btnR * 2);

    textSize(24);
    textAlign(LEFT);
    fill(255,255,255);
    text("R", runBtnPos.x   - 8, runBtnPos.y   + 9);
    text("T", trainBtnPos.x - 7, trainBtnPos.y + 8);
    fill(0,0,0);
    text("M", memoryBtnPos.x - 9, memoryBtnPos.y + 8);
    text("R", recallBtnPos.x - 8, recallBtnPos.y + 8);

    textSize(18)
    textAlign(CENTER);
    fill(255,255,255);
    text(trainingSetIdx + "/" + trainingSet.size(),
         recallBtnPos.x - btnR, recallBtnPos.y + btnR, btnR * 2, 18);

    nn.move();
    nn.draw();
}

void registerCurrentTrainingSet() {
    float[] set = nn.getTrainingSet();
    trainingSet.add(set);
}

void changeToNextTrainingSet() {
    trainingSetIdx++;
    if( trainingSet.size() <= trainingSetIdx ) {
        trainingSetIdx = 0;
    }
    float[] currentSet = (ArrayList)trainingSet.get(trainingSetIdx);
    nn.setTrainingSet(currentSet);
}

void selectRandomTrainingSet() {
    trainingSetIdx = (int)random(trainingSet.size());
    float[] currentSet = (ArrayList)trainingSet.get(trainingSetIdx);
    nn.setTrainingSet(currentSet);
}

void fadeToBlack() {
    noStroke();
    fill(0, 50);
    rectMode(CORNER);
    rect(0, 0, width, height);
}

void flashScreen() {
    noStroke();
    fill(255,50);
    rectMode(CORNER);
    rect(0, 0, width, height);
}

void mouseMoved()
{
    Neuron closest = null;
    float minDist = 0.0;

    for( int i = 0 ; i < nn.getNeuronCount() ; i++ ) {
        Neuron n = nn.getNeuronAt(i);
        n.mouseOver(false);
    }

    for( int i = 0 ; i < nn.getNeuronCount() ; i++ ) {
        PVector mousePos = new PVector(mouseX, mouseY);
        Neuron n = nn.getNeuronAt(i);
        float dist = mousePos.dist(n.pos);
        if(( closest == null || dist < minDist ) && dist < n.getRadius()) {
//        if( closest == null || dist < minDist ) {
            minDist = dist;
            closest = n;
        }
    }

    if( closest != null ) {
        closest.mouseOver(true);
    }
}

void mousePressed() {
    PVector mousePos = new PVector(mouseX, mouseY);

    selected = null;
    float minDist = 0.0;
    for( int i = 0 ; i < nn.getNeuronCount() ; i++ ) {
        Neuron n = nn.getNeuronAt(i);
        float dist = mousePos.dist(n.pos);
        if(( selected == null || dist < minDist ) && dist < n.getRadius()) {
            minDist = dist;
            selected = n;
        }
    }

    if( selected != null ) {
        selected.fixed(true);
        selected.setPosition(mouseX, mouseY);
        if( !training ) {
            selected.mousePressed();
        }
    }

    if( mousePos.dist(runBtnPos) < btnR ) {
        running = (running == true) ? false : true;
        flashScreen();
    } else if( mousePos.dist(trainBtnPos) < btnR ) {
        training = (training == true) ? false : true;
        trainingCount = 0;
        flashScreen();
    } else if( mousePos.dist(memoryBtnPos) < btnR ) {
        registerCurrentTrainingSet();
        flashScreen();
    } else if( mousePos.dist(recallBtnPos) < btnR ) {
        changeToNextTrainingSet();
//        flashScreen();
    }
}

void mouseDragged() {
    if( selected != null ) {
        selected.setPosition(mouseX, mouseY);
    }
}

void mouseReleased() {
    for( int i = 0 ; i < nn.getNeuronCount() ; i++ ) {
        Neuron n = nn.getNeuronAt(i);
        n.fixed(false);
    }
    selected = null;
}
