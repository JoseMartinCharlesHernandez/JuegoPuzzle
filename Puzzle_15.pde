Handle[] handles;
boolean labelpressed=false,end=false;
int num=15, minsizex, minsizey, xcatch=0, ycatch=0,rand=1;
float odometro =0;

float angle=0;

void setup()
{
  size(400, 400);
  handles = new Handle[num];
  minsizex = width/4;
  minsizey = height/4;
  int col=150;
  
  handles[0] = new Handle(0, 0,          0,          0,  minsizex,  minsizey, 255,255,255,handles, 0);
  handles[1] = new Handle(0, 0,   minsizex,          0,  minsizex,  minsizey, 255,0,0,    handles, 1);
  handles[2] = new Handle(0, 0, 2*minsizex,          0,  minsizex,  minsizey, 255,0,0,    handles, 2);
  handles[3] = new Handle(0, 0, 3*minsizex,          0,  minsizex,  minsizey, 255,0,0,    handles, 3);
  handles[4] = new Handle(0, 0,          0,   minsizey,  minsizex,  minsizey, 255,0,0,    handles, 4);
  handles[5] = new Handle(0, 0,   minsizex,   minsizey,  minsizex,  minsizey, 255,0,0,    handles, 5);
  handles[6] = new Handle(0, 0, 2*minsizex,   minsizey,  minsizex,  minsizey, 255,255,0,  handles, 6);
  handles[7] = new Handle(0, 0, 3*minsizex,   minsizey,  minsizex,  minsizey, 255,255,0,  handles, 7);
  handles[8] = new Handle(0, 0,          0, 2*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 8);
  handles[9] = new Handle(0, 0,   minsizex, 2*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 9);
  handles[10] =new Handle(0, 0, 2*minsizex, 2*minsizey,  minsizex,  minsizey, 255,0,0,    handles, 10);
  handles[11] =new Handle(0, 0, 3*minsizex, 2*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 11);
  handles[12] =new Handle(0, 0,          0, 3*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 12);
  handles[13] =new Handle(0, 0,   minsizex, 3*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 14);
  handles[14] =new Handle(0, 0, 2*minsizex, 3*minsizey,  minsizex,  minsizey, 255,255,0,  handles, 13);
  
}

void keyPressed()
{
  char k;
  k = (char)key;
  if (k=='r') {rand++;}  
}

void draw()
{
  background(0);
  fill(100);
  ellipse(width/2,height-minsizey,minsizex/2,minsizey/2);
  if(end==false){
    int j = (int) random(-2,num); //random piece
    if (j<1) j=0;                 //more weigth for the white piece
    if (((float) rand/2.)==(float)(rand/2)) { handles[j].randommove(); }     //random move for the selected random piece
    for(int i=0; i<num; i++) {
      handles[i].update();
      handles[i].display();
    }
  }
  if (abs(handles[0].lengthx+handles[0].sizex/2-width/2)<4 && 
       abs(handles[0].lengthy+handles[0].sizey/2-height+minsizey)<4)
   {end=true;}
  fill(10,10,10) ;
  text( (int) odometro,handles[0].lengthx+10, handles[0].lengthy+20);
}

void mouseReleased() 
{
  for(int i=0; i<num; i++) {
    handles[i].release();
  }
  labelpressed  = false;
}

class Handle
{
  int x, y;
  int boxx, boxy;
  int lengthx, lengthy;
  int sizex;
  int sizey;
  boolean over;
  boolean press;
  int colr,colg,colb;
  boolean locked = false;
  boolean otherslocked = false;
  Handle[] others;
  int index;
  int lastmovex=0, lastmovey=0;
  
  Handle(int ix, int iy, int ll, int ly,int il, int is, int ired, int igr, int ibl,Handle[] o, int ind)
  {
    x = ix;
    y = iy;
    lengthx = ll;
    lengthy = ly;
    sizex = il;
    sizey = is;
    boxx = x+lengthx - sizex/2;
    boxy = y+lengthy - sizey/2;
    colr = ired;
    colg = igr;
    colb = ibl;
    others = o;
    index = ind;
  }
  
  void update() 
  {
    boxx = x+lengthx;
    boxy = y +lengthy;
    
    for(int i=0; i<others.length; i++) {
      if(others[i].locked == true) {
        otherslocked = true;
        break;
      } else {
        otherslocked = false;
      }  
    }
    
    if(otherslocked == false) {
      over();
      press();
    }  
   
    if(press) {
      int  tlengthx = lock(mouseX-xcatch, 0, width-sizex);
      int  tlengthy = lock(mouseY-ycatch, 0, height-sizey);
      int m=moveto(tlengthx,tlengthy);
      if (m==1 || m==3)  {odometro+= (float) abs(lengthx-tlengthx)/(float)minsizex;lengthx=tlengthx;}
      if (m==2 || m==3)  {odometro+= (float) abs(lengthy-tlengthy)/(float)minsizey;lengthy=tlengthy;}

        }
  }
  
    int moveto(int tlengthx,int tlengthy){
    int xfree=0 ;
    int yfree=0, m=0;
    for(int i=0; i<others.length; i++) {
      if (index!=others[i].index){
        if ((abs(tlengthy+sizey/2-others[i].lengthy-others[i].sizey/2) >= sizey/2+others[i].sizey/2-2) || (abs(lengthx+sizex/2-others[i].lengthx-others[i].sizex/2) >= sizex/2+others[i].sizex/2-2) ){                   
          yfree++;      
        }
        if ((abs(tlengthx+sizex/2-others[i].lengthx-others[i].sizex/2) >= sizex/2+others[i].sizex/2-2) || (abs(lengthy+sizey/2-others[i].lengthy-others[i].sizey/2) >= sizey/2+others[i].sizey/2-2) ){                   
          xfree++;
        }
      }
    }
    if (xfree==num-1 && abs(lengthx-tlengthx)<minsizex)  {m+=1;}
    if (yfree==num-1 && abs(lengthy-tlengthy)<minsizey)  {m+=2;}
    return m;
  }
  
  void randommove(){
    int i = 2*((int) random(-2,0))+1, j= 2*((int) random(-2,0))+1, m=0;
    if (index==0 && i<1) {i=i+(int) random(0,2);}
  
    lastmovex=i;
    lastmovey=j;   
    int tlengthx=lock(lengthx+i*(minsizex-1)/2, 0, width-sizex);
    int tlengthy=lock(lengthy+j*(minsizey-1)/2, 0, height-sizey);
    m=moveto(tlengthx, tlengthy);
    if (m>0){
      tlengthx=lock(lengthx+i*(minsizex-1), 0, width-sizex);
      tlengthy=lock(lengthy+j*(minsizey-1), 0, height-sizey);
      m=moveto(tlengthx, tlengthy);
      if (m==1 )  {odometro+= (float) abs(lengthx-tlengthx)/(float)minsizex;lengthx=tlengthx;}
      if (m==2 )  {odometro+= (float) abs(lengthy-tlengthy)/(float)minsizey;lengthy=tlengthy;}
      match();
      }
  }
  
  void over()
  {
    if(overRect(boxx, boxy, sizex, sizey)) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void press()
  {
    if (over && mousePressed && labelpressed == false){
      xcatch=mouseX-lengthx;
      ycatch=mouseY-lengthy;
      labelpressed = true;
    }  
  
    if(over && mousePressed || locked) {
      press = true;
      locked = true;
    } else {
      press = false;
    }
  }
  
  void release()
  {
    if (locked == true) {match();}
    locked = false;
  }
  
  int round(int z, int razon){
    int res=z, mod = z%razon;
    if (mod < 8)         {res=z-mod; odometro+=(float) mod/ (float) razon;}
    if (mod > (razon-8)) {res=z+razon-mod; odometro+=(float) (razon-mod)/ (float) razon;}
    return res;
  }
  
  void match()
  {
    lengthx=round(lengthx,minsizex);
    lengthy=round(lengthy,minsizey);
    update();
  }
   
  
  void display() 
  {

    fill(85,30,10);

    stroke(0);
    rect(boxx, boxy, sizex, sizey);
    fill (255,255,255);
    text( (int) index+1,boxx+minsizex/2, boxy+minsizex/2);


  }
}

boolean overRect(int x, int y, int width, int height) 
{
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

int lock(int val, int minv, int maxv) 
{ 
  return  min(max(val, minv), maxv); 
} 
