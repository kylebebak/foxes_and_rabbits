int swarm=25;
int npred=15;
//swarm and npred can change
int minswarm=25;
int minpred=15;
//minimum number of prey and predators, maybe not realistic but necessary
int maxswarm=800;
//max number of prey

int maxbirth=1;
//max number of offspring of predators can have after eating prey, gets rounded to an integer in sketch
float birthf=.8;
//probability of predator reproducing after eating prey
float rs=.015;
//reproduction rate of swarm, implemented as probability of repdroduction
float drp=.0175;
//death rate of predators, implemented as probability of death
float r;
//random variable for implementing probabilities

float Lm=500;
float Lv=75;
float Ls=25;
float Lp=125;
float Km=25;
float Kv=.4;
float Ks=.6;
float Kp=5.5;
float K1prey=20;
float K1=10;
//interaction lengths and strengths for mouse, prey, and predators
//mouse is strongest, then predators interacting with prey
//K1s are for one-on-one, where predator only chases nearest prey
//and prey only flees nearest predator
float Lk=4.5;
//kill length, if predator gets within this range of prey prey gets eaten
float dt;

float vmi=5.5;
float vma=6.5;
float dvmi=1.25;
float dvma=1.75;
//speed and acceleration of prey chosen randomly between these values
float vpmi=5;
float vpma=10;
float dvpmi=1;
float dvpma=2;
//speed and acceleration of predators chosen randomly between these values



float a;
float b;
float vratio;
float dvratio;
//for normalization of velocity, acceleration
float hratio;
float wratio;
float hpratio;
float wpratio;
float htri=12;
float wtri=6;
//for rendering triangles, this determines their sizes
PFont ff;
//for drawing the number of prey and predators in the image

float[] hx;
float[] hy;
float[] wx;
float[] wy;
float[] hxp;
float[] hyp;
float[] wxp;
float[] wyp;
//for rendering triangles
float scaleT=1.5;
//size of predators divided by size of prey

float[] x;
float[] y;
float[] xp;
float[] yp;
float[] vx;
float[] vy;
float[] vxp;
float[] vyp;
float[] dvx;
float[] dvy;
float[] dvxm;
float[] dvym;
float[] dvxi;
float[] dvyi;
float[] vmax;
float[] dvmax;
float[] dvxp;
float[] dvyp;
float[] vpmax;
float[] dvpmax;
//arrays controlling motion and position

float[] xt;
float[] yt;
float[] vxt;
float[] vyt;
float[] vmaxt;
float[] dvmaxt;
//temporary arrays for adding/subtracting swarm members

float[] xpt;
float[] ypt;
float[] vxpt;
float[] vypt;
float[] vpmaxt;
float[] dvpmaxt;
//temporary arrays for adding/subtracting predators



int res=400;
float resf=res;
float[] n1a=new float[res]; //prey
float[] n2a=new float[res]; //predators
//for drawing a graph of their respective populations in real time
boolean toggleGraph;
//for toggling graph on and off


void setup() {


  ff=createFont("EurostileBold", 48);
  //"EurostileBold-48.vlw"

  size(950, 700);
  frameRate(25);
  ellipseMode(CENTER);

  x=new float[swarm];
  y=new float[swarm];
  vx=new float[swarm];
  vy=new float[swarm];
  vmax=new float[swarm];
  dvmax=new float[swarm];

  xp=new float[npred];
  yp=new float[npred];
  vxp=new float[npred];
  vyp=new float[npred];
  vpmax=new float[npred];
  dvpmax=new float[npred];

  for (int i=0; i<=swarm-1; i=i+1) {
    x[i]=random(0, width);
    y[i]=random(0, height);
    vmax[i]=random(vmi, vma);
    dvmax[i]=random(dvmi, dvma);
    vx[i]=random(-vmax[i], vmax[i]);
    vy[i]=random(-vmax[i], vmax[i]);
  }

  for (int i=0; i<npred-1; i++) {
    xp[i]=random(0, width);
    yp[i]=random(0, height);
    vpmax[i]=random(vpmi, vpma);
    dvpmax[i]=random(dvpmi, dvpma);
    vxp[i]=random(-vpmax[i], vpmax[i]);
    vyp[i]=random(-vpmax[i], vpmax[i]);
  }
}


void draw() {


  smooth();
  noStroke();
  background(0);

  //adding or subtracting new members to swarm 
  if (keyPressed) {
    if (swarm<maxswarm) {
      if (key == '=') {
        swarm+=1;
      }
    }
    if (swarm>minswarm) {
      if (key == '-') {
        swarm-=1;
      }
    }

    //adding or subtracting new predators
    if (key == '2') {
      npred+=1;
    }
    if (key == '1') {
      if (npred>minpred) {
        npred-=1;
      }
    }

    if ((key == '=') || (key == '-')) {
      xt=new float[swarm];
      yt=new float[swarm];
      vxt=new float[swarm];
      vyt=new float[swarm];
      vmaxt=new float[swarm];
      dvmaxt=new float[swarm];

      for (int i=0; i<=swarm-2; i=i+1) {
        xt[i]=x[i];
        yt[i]=y[i];
        vxt[i]=vx[i];
        vyt[i]=vy[i];
        vmaxt[i]=vmax[i];
        dvmaxt[i]=dvmax[i];
      }
      x=new float[swarm];
      y=new float[swarm];
      vx=new float[swarm];
      vy=new float[swarm];
      vmax=new float[swarm];
      dvmax=new float[swarm];

      for (int i=0; i<=swarm-2; i=i+1) {
        x[i]=xt[i];
        y[i]=yt[i];
        vmax[i]=vmaxt[i];
        dvmax[i]=dvmaxt[i];
        vx[i]=vxt[i];
        vy[i]=vyt[i];
      }
      if (swarm!=0) {
        x[swarm-1]=mouseX;
        y[swarm-1]=mouseY;
        vmax[swarm-1]=random(vmi, vma);
        dvmax[swarm-1]=random(dvmi, dvma);
        vx[swarm-1]=random(-vmax[swarm-1], vmax[swarm-1]);
        vy[swarm-1]=random(-vmax[swarm-1], vmax[swarm-1]);
      }
    }

    if ((key == '2') || (key == '1')) {
      xpt=new float[npred];
      ypt=new float[npred];
      vxpt=new float[npred];
      vypt=new float[npred];
      vpmaxt=new float[npred];
      dvpmaxt=new float[npred];

      for (int i=0; i<=npred-2; i=i+1) {
        xpt[i]=xp[i];
        ypt[i]=yp[i];
        vxpt[i]=vxp[i];
        vypt[i]=vyp[i];
        vpmaxt[i]=vpmax[i];
        dvpmaxt[i]=dvpmax[i];
      }
      xp=new float[npred];
      yp=new float[npred];
      vxp=new float[npred];
      vyp=new float[npred];
      vpmax=new float[npred];
      dvpmax=new float[npred];

      for (int i=0; i<=npred-2; i=i+1) {
        xp[i]=xpt[i];
        yp[i]=ypt[i];
        vpmax[i]=vpmaxt[i];
        dvpmax[i]=dvpmaxt[i];
        vxp[i]=vxpt[i];
        vyp[i]=vypt[i];
      }
      if (npred!=0) {
        xp[npred-1]=mouseX;
        yp[npred-1]=mouseY;
        vpmax[npred-1]=random(vpmi, vpma);
        dvpmax[npred-1]=random(dvpmi, dvpma);
        vxp[npred-1]=random(-vpmax[npred-1], vpmax[npred-1]);
        vyp[npred-1]=random(-vpmax[npred-1], vpmax[npred-1]);
      }
    }
  }

  dvx=new float[swarm];
  dvy=new float[swarm];
  dvxm=new float[swarm];
  dvym=new float[swarm];
  dvxi=new float[swarm];
  dvyi=new float[swarm];
  dvxp=new float[npred];
  dvyp=new float[npred];
  hx=new float[swarm];
  hy=new float[swarm];
  wx=new float[swarm];
  wy=new float[swarm];
  hxp=new float[npred];
  hyp=new float[npred];
  wxp=new float[npred];
  wyp=new float[npred];

  //rendering predators as triangles
  for (int i=0; i<npred; i++) {
    fill(255, 0, 0);
    if ((vxp[i]==0) && (vyp[i]==0)) {
      ellipse(xp[i], yp[i], wtri, wtri);
    } 
    else {
      hratio=htri/dist(vxp[i], vyp[i], 0, 0);
      hxp[i]=-hratio*vxp[i];
      hyp[i]=-hratio*vyp[i];
      wratio=hratio*(wtri/htri);
      wxp[i]=wratio*vyp[i];
      wyp[i]=wratio*vxp[i];
      triangle(xp[i], yp[i], xp[i]+scaleT*hxp[i]+scaleT*wxp[i]/2, yp[i]+scaleT*hyp[i]-scaleT*wyp[i]/2, xp[i]+scaleT*hxp[i]-scaleT*wxp[i]/2, yp[i]+scaleT*hyp[i]+scaleT*wyp[i]/2);
    }
  }
  noStroke();

  //rendering swarm as triangles
  for (int i=0; i<=swarm-1; i=i+1) {
    fill(255);
    if ((vx[i]==0) && (vy[i]==0)) {
      ellipse(x[i], y[i], wtri, wtri);
    } 
    else {
      hratio=htri/dist(vx[i], vy[i], 0, 0);
      hx[i]=-hratio*vx[i];
      hy[i]=-hratio*vy[i];
      wratio=hratio*(wtri/htri);
      wx[i]=wratio*vy[i];
      wy[i]=wratio*vx[i];
      triangle(x[i], y[i], x[i]+hx[i]+wx[i]/2, y[i]+hy[i]-wy[i]/2, x[i]+hx[i]-wx[i]/2, y[i]+hy[i]+wy[i]/2);
    }
  }

  float xtt=0, ytt=0;
  //motion control for swarm-mouse interaction
  if (mousePressed==true) {
    for (int i=0; i<=swarm-1; i=i+1) {
      float[] c=distloop(x[i], y[i], mouseX, mouseY);
      xtt=c[0];
      ytt=c[1];
      dt=dist(xtt, ytt, mouseX, mouseY);
      if (dt>0 && dt<Lm) {
        if (dt<16) {
          dvxm[i]=-(Km/64)*(xtt-mouseX);
          dvym[i]=-(Km/64)*(ytt-mouseY);
        } 
        else {
          dt=dt*sqrt(dt);
          dvxm[i]=-Km*(xtt-mouseX)/dt;
          dvym[i]=-Km*(ytt-mouseY)/dt;
        }
      }
    }
  }


  //motion control for swarm-prey/predator interaction
  xt=new float[swarm];
  yt=new float[swarm];
  xpt=new float[npred];
  ypt=new float[npred];
  arrayCopy(x, xt);
  arrayCopy(y, yt);
  arrayCopy(xp, xpt);
  arrayCopy(yp, ypt);

  float xptt=0, yptt=0;

  for (int i=0; i<=swarm-1; i=i+1) {
    float b=0;
    for (int j=0; j<npred; j++) {
      float[] c=distloop(xp[j], yp[j], x[i], y[i]);
      xptt=c[0];
      yptt=c[1];
      dt=dist(xt[i], yt[i], xptt, yptt);

      if (dt>0 && dt<Lp) {
        if (dt<16) {
          dvxi[i]+=Kp*(xt[i]-xptt)/64;
          dvyi[i]+=Kp*(yt[i]-yptt)/64;
          dvxp[j]+=Kp*(xt[i]-xptt)/64;
          dvyp[j]+=Kp*(yt[i]-yptt)/64;
        } 
        else {
          dt=dt*sqrt(dt);
          dvxi[i]+=Kp*(xt[i]-xptt)/dt;
          dvyi[i]+=Kp*(yt[i]-yptt)/dt;
          dvxp[j]+=Kp*(xt[i]-xptt)/dt;
          dvyp[j]+=Kp*(yt[i]-yptt)/dt;
        }
        b=b+1;
      }
    }
    if (b>0) {
      dvxi[i]=dvxi[i]/b;
      dvyi[i]=dvyi[i]/b;
    }
  }


  //motion control for swarm-swarm interaction
  for (int i=0; i<=swarm-1; i=i+1) {
    float dvxt, dvyt;
    float a=0;
    for (int j=i+1; j<=swarm-1; j=j+1) {
      float[] c=distloop(x[j], y[j], x[i], y[i]);
      xtt=c[0];
      ytt=c[1];
      dt=dist(xtt, ytt, x[i], y[i]);
      if (dt<Lv) {
        //coherence (moving in the same direction)
        dvx[i]+=Kv*vx[j]/sqrt(max(dt, 10));
        dvy[i]+=Kv*vy[j]/sqrt(max(dt, 10));
        dvx[j]+=Kv*vx[i]/sqrt(max(dt, 10));
        dvy[j]+=Kv*vy[i]/sqrt(max(dt, 10));
        //cohesion and separation (not being too near or too far)
        a=a+1;
        dvxt=Ks*(xtt-x[i])*signum(dt-Ls)/sq(max(dt, 7.5));
        dvyt=Ks*(ytt-y[i])*signum(dt-Ls)/sq(max(dt, 7.5));
        dvx[i]+=dvxt;
        dvy[i]+=dvyt;
        dvx[j]-=dvxt;
        dvy[j]-=dvyt;
      }
    }
    if (a>0) {
      dvx[i]=dvx[i]/a;
      dvy[i]=dvy[i]/a;
    }
  }

  for (int i=0; i<=swarm-1; i=i+1) {
    dvx[i]+=dvxi[i]+dvxm[i];
    dvy[i]+=dvyi[i]+dvym[i];
  }


  //normalization and movement looping for prey/predator
  for (int i=0; i<npred; i++) {
    if ((sq(dvxp[i])+sq(dvyp[i]))>sq(dvpmax[i])) {
      dvratio=dvpmax[i]/dist(dvxp[i], dvyp[i], 0, 0);
      dvxp[i]=dvratio*dvxp[i];
      dvyp[i]=dvratio*dvyp[i];
    }

    vxp[i]=vxp[i]+dvxp[i];
    vyp[i]=vyp[i]+dvyp[i];

    if ((sq(vxp[i])+sq(vyp[i]))>sq(vpmax[i])) {
      vratio=vpmax[i]/dist(vxp[i], vyp[i], 0, 0);
      vxp[i]=vratio*vxp[i];
      vyp[i]=vratio*vyp[i];
    }

    xp[i]=xp[i]+vxp[i];
    yp[i]=yp[i]+vyp[i];

    if (xp[i]>width+htri) {
      xp[i]=xp[i]-(width+htri);
    }
    if (xp[i]<0-htri) {
      xp[i]=xp[i]+(width+htri);
    }

    if (yp[i]>height+htri) {
      yp[i]=yp[i]-(height+htri);
    }
    if (yp[i]<0-htri) {
      yp[i]=yp[i]+(height+htri);
    }
  }

  for (int i=0; i<=swarm-1; i=i+1) {
    //normalization of dv
    if ((sq(dvx[i])+sq(dvy[i]))>sq(dvmax[i])) {
      dvratio=dvmax[i]/dist(dvx[i], dvy[i], 0, 0);
      dvx[i]=dvratio*dvx[i];
      dvy[i]=dvratio*dvy[i];
    }

    vx[i]=vx[i]+dvx[i];
    vy[i]=vy[i]+dvy[i];

    //normalization of v
    if ((sq(vx[i])+sq(vy[i]))>sq(vmax[i])) {
      vratio=vmax[i]/dist(vx[i], vy[i], 0, 0);
      vx[i]=vratio*vx[i];
      vy[i]=vratio*vy[i];
    }

    x[i]=x[i]+vx[i];
    y[i]=y[i]+vy[i];

    //looping
    if (x[i]>width+htri) {
      x[i]=x[i]-(width+htri);
    }
    if (x[i]<0-htri) {
      x[i]=x[i]+(width+htri);
    }

    if (y[i]>height+htri) {
      y[i]=y[i]-(height+htri);
    }
    if (y[i]<0-htri) {
      y[i]=y[i]+(height+htri);
    }
  }


  //here's where the magic is going to have to happen, arrayCopy will be useful
  //arrayCopy(src, srcPos (start), dest, destPos (start), length)
  int npredt=npred;
  //npred changes while npredt doesn't, and we only count up to npredt
  //this prevents new predators from eating the same turn they're born
  for (int j=0; j<npredt; j++) {
    for (int i=0; i<swarm; i++) {
      if (dist(xp[j], yp[j], x[i], y[i])<Lk) {
        if (swarm>minswarm) { 
          swarm-=1;

          xt=new float[swarm];
          yt=new float[swarm];
          vmaxt=new float[swarm];
          dvmaxt=new float[swarm];
          vxt=new float[swarm];
          vyt=new float[swarm];

          arrayCopy(x, 0, xt, 0, i);
          arrayCopy(x, i+1, xt, i, swarm-i);
          x=new float[swarm];
          arrayCopy(xt, x);

          arrayCopy(y, 0, yt, 0, i);
          arrayCopy(y, i+1, yt, i, swarm-i);
          y=new float[swarm];
          arrayCopy(yt, y);

          arrayCopy(vx, 0, vxt, 0, i);
          arrayCopy(vx, i+1, vxt, i, swarm-i);
          vx=new float[swarm];
          arrayCopy(vxt, vx);

          arrayCopy(vy, 0, vyt, 0, i);
          arrayCopy(vy, i+1, vyt, i, swarm-i);
          vy=new float[swarm];
          arrayCopy(vyt, vy);

          arrayCopy(vmax, 0, vmaxt, 0, i);
          arrayCopy(vmax, i+1, vmaxt, i, swarm-i);
          vmax=new float[swarm];
          arrayCopy(vmaxt, vmax);

          arrayCopy(dvmax, 0, dvmaxt, 0, i);
          arrayCopy(dvmax, i+1, dvmaxt, i, swarm-i);
          dvmax=new float[swarm];
          arrayCopy(dvmaxt, dvmax);

          for (int m=0; m<maxbirth; m++) {
            r=random(1);
            if (r<birthf) {
              npred+=1;

              xpt=new float[npred];
              ypt=new float[npred];
              vpmaxt=new float[npred];
              dvpmaxt=new float[npred];
              vxpt=new float[npred];
              vypt=new float[npred];

              arrayCopy(xp, 0, xpt, 0, npred-1);
              xp=new float[npred];
              arrayCopy(xpt, 0, xp, 0, npred-1);
              xp[npred-1]=xp[j];
              //newborn predator(s) born where parent is

              arrayCopy(yp, 0, ypt, 0, npred-1);
              yp=new float[npred];
              arrayCopy(ypt, 0, yp, 0, npred-1);
              yp[npred-1]=yp[j];
              //newborn predator(s) born where parent is

              arrayCopy(vpmax, 0, vpmaxt, 0, npred-1);
              vpmax=new float[npred];
              arrayCopy(vpmaxt, 0, vpmax, 0, npred-1);
              vpmax[npred-1]=random(vpmi, vpma);

              arrayCopy(dvpmax, 0, dvpmaxt, 0, npred-1);
              dvpmax=new float[npred];
              arrayCopy(dvpmaxt, 0, dvpmax, 0, npred-1);
              dvpmax[npred-1]=random(dvpmi, dvpma);

              arrayCopy(vxp, 0, vxpt, 0, npred-1);
              vxp=new float[npred];
              arrayCopy(vxpt, 0, vxp, 0, npred-1);
              vxp[npred-1]=random(-vpmax[npred-1], vpmax[npred-1]);

              arrayCopy(vyp, 0, vypt, 0, npred-1);
              vyp=new float[npred];
              arrayCopy(vypt, 0, vyp, 0, npred-1);
              vyp[npred-1]=random(-vpmax[npred-1], vpmax[npred-1]);
            }
          }
          break;
          //end prey loop, move on to next predator so that one predator can't eat several prey
        }
      }
    }
  }


  //death of predators. new predators don't die the same turn they're born
  int deadpred=0;
  for (int i=0; i<npredt; i++) {
    float r=random(1);
    if (r<drp) {
      deadpred+=1;
    }
  }

  if (npred-deadpred>minpred-1) {
    xpt=new float[npred];
    ypt=new float[npred];
    vpmaxt=new float[npred];
    dvpmaxt=new float[npred];
    vxpt=new float[npred];
    vypt=new float[npred];

    arrayCopy(xp, xpt);
    xp=new float[npred-deadpred];
    arrayCopy(xpt, deadpred, xp, 0, npred-deadpred);

    arrayCopy(yp, ypt);
    yp=new float[npred-deadpred];
    arrayCopy(ypt, deadpred, yp, 0, npred-deadpred);

    arrayCopy(vxp, vxpt);
    vxp=new float[npred-deadpred];
    arrayCopy(vxpt, deadpred, vxp, 0, npred-deadpred);

    arrayCopy(vyp, vypt);
    vyp=new float[npred-deadpred];
    arrayCopy(vypt, deadpred, vyp, 0, npred-deadpred);

    arrayCopy(vpmax, vpmaxt);
    vpmax=new float[npred-deadpred];
    arrayCopy(vpmaxt, deadpred, vpmax, 0, npred-deadpred);

    arrayCopy(dvpmax, dvpmaxt);
    dvpmax=new float[npred-deadpred];
    arrayCopy(dvpmaxt, deadpred, dvpmax, 0, npred-deadpred);

    npred-=deadpred;
  }


  //reproduction of prey. newborns can't reproduce, just like newborn predators can't eat
  int swarmt=swarm;
  for (int i=0; i<swarmt; i++) {
    if (swarm<maxswarm) {
      float r=random(1);
      if (r<rs) {

        swarm+=1;

        xt=new float[swarm];
        yt=new float[swarm];
        vmaxt=new float[swarm];
        dvmaxt=new float[swarm];
        vxt=new float[swarm];
        vyt=new float[swarm];

        arrayCopy(x, 0, xt, 0, swarm-1);
        x=new float[swarm];
        arrayCopy(xt, 0, x, 0, swarm-1);
        x[swarm-1]=x[i];
        //newborn prey born where parent is

        arrayCopy(y, 0, yt, 0, swarm-1);
        y=new float[swarm];
        arrayCopy(yt, 0, y, 0, swarm-1);
        y[swarm-1]=y[i];
        //newborn prey born where parent is

        arrayCopy(vmax, 0, vmaxt, 0, swarm-1);
        vmax=new float[swarm];
        arrayCopy(vmaxt, 0, vmax, 0, swarm-1);
        vmax[swarm-1]=random(vmi, vma);

        arrayCopy(dvmax, 0, dvmaxt, 0, swarm-1);
        dvmax=new float[swarm];
        arrayCopy(dvmaxt, 0, dvmax, 0, swarm-1);
        dvmax[swarm-1]=random(dvmi, dvma);

        arrayCopy(vx, 0, vxt, 0, swarm-1);
        vx=new float[swarm];
        arrayCopy(vxt, 0, vx, 0, swarm-1);
        vx[swarm-1]=random(-vma, vma);

        arrayCopy(vy, 0, vyt, 0, swarm-1);
        vy=new float[swarm];
        arrayCopy(vyt, 0, vy, 0, swarm-1);
        vy[swarm-1]=random(-vma, vma);
      }
    }
  }


  //for drawing graphs of their numbers in real time
  for (int i=res-1; i>0; i--) {
    n1a[i]=n1a[i-1];
    n2a[i]=n2a[i-1];
  }

  n1a[0]=swarm;
  n2a[0]=npred;

  noSmooth();

  if (toggleGraph) {
    for (int j=0; j<res-1; j++) {
      float jf=j;
      strokeWeight(2);
      stroke(255);
      line(.85*width*(1-jf/resf), height*(1-.75*n1a[j]/maxswarm), .85*width*(1-(jf+1)/resf), height*(1-.75*n1a[j+1]/maxswarm));
      stroke(255, 0, 0);
      line(.85*width*(1-jf/resf), height*(1-.75*n2a[j]/maxswarm), .85*width*(1-(jf+1)/resf), height*(1-.75*n2a[j+1]/maxswarm));
    }
  }

  smooth();
  noStroke();
  textFont(ff, 12);
  fill(255);
  String number = "N = " + nf(swarm, 1, 1);
  String numberp = "NP = " + nf(npred, 1, 1);
  text(number, 20, 25);
  text(numberp, 20, 45);
  
  
  
  
  /*******************
  END OF DRAW LOOP
  *******************/
//  saveFrame("/Users/kylebebak/Desktop/predator_prey_images/####.tif");
}

void keyReleased() {
  if (key == 'g') toggleGraph = !toggleGraph;
}



float[] distloop(float x1, float y1, float x2, float y2) {

  /*point coords are changed to values that minimize the distance
   between the points, assuming that the screen loops along x and y
   */

  if ( abs(x1-x2) > width/2 ) {
    if (x1>x2) x1-=width;
    else x1+=width;
  }
  if ( abs(y1-y2) > height/2 ) {
    if (y1>y2) y1-=height;
    else y1+=height;
  }

  float[] coords= {
    x1, y1
  };
  return coords;
}

float signum (float input) {
  if (input >= 0) return 1.0;
  else return -1.0;
}













// enable full scree mode, TRULY FULL SCREEN!
boolean sketchFullScreen() {
  return true;
}

