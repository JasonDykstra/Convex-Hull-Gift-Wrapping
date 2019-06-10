Convex_Hull hull;

ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> velocities = new ArrayList<PVector>();

float max_drift = 5;
float acceleration = 0;

ArrayList<PVector> detection_points = new ArrayList<PVector>();
ArrayList<PVector> detection_velocities = new ArrayList<PVector>();
boolean[] detection;

int numPoints = 20;
int numDetectionPoints = 5;

int border_gap = 5;
int top_border;
int bottom_border;
int right_border;
int left_border;




void setup() {
  fullScreen();

  top_border = 0;
  bottom_border = height;
  right_border = width;
  left_border = 50;

  for (int i=0; i<numPoints; i++) {
    points.add(new PVector(random(left_border, right_border), random(top_border, bottom_border)));
  }
  //GIVE HULL POINTS RANDOM VELOCITIES
  for (int i=0; i<numPoints; i++) {
    velocities.add(new PVector(random(-max_drift, max_drift), random(-max_drift, max_drift)));
  }

  hull = new Convex_Hull(points);

  for (int i=0; i<numDetectionPoints; i++) {
    detection_points.add(new PVector(random(left_border, right_border), random(top_border, bottom_border)));
  }
  //GIVE DETECTION POINTS RANDOM VELOCITIES
  for (int i=0; i<numDetectionPoints; i++) {
    detection_velocities.add(new PVector(random(-max_drift, max_drift), random(-max_drift, max_drift)));
  }

  detection = new boolean[numDetectionPoints];
}




void mouseClicked() {
  boolean add = true;
  for (PVector point : points) {
    if (point.x!=mouseX && point.y!=mouseY) {
    } else {
      add=false;
    }
  }
  if (add==true) {
    if (mouseX > left_border && mouseX < right_border && mouseY > top_border && mouseY < bottom_border) {
      points.add(new PVector(mouseX, mouseY));
      numPoints+=1;
      velocities.add(new PVector(random(-max_drift, max_drift), random(-max_drift, max_drift)));
    }
  }
}




void draw() {
  background(255);
  hull.run();
  for (int i=0; i<numDetectionPoints; i++) {
    detection[i] = hull.contains(detection_points.get(i));
  }    
  border();
  hull_random();
  //hull_gravity();
  detection_random();
  //detection_gravity();

  for (int i=0; i<numDetectionPoints; i++) {
    if (detection[i]) {
      stroke(0, 255, 0);
    } else {
      stroke(0, 0, 255);
    }
    rectMode(RADIUS);
    rect(detection_points.get(i).x, detection_points.get(i).y, border_gap, border_gap);
  } 

  fill(0);
  textSize(50);
  textAlign(LEFT, TOP);
  text("Area: " + nfc(int(hull.getArea())) + " square pixels", 20, 20);
  text("Perimeter: " + nfc(int(hull.getPerimeter()))+ " pixels", 20, 80);

  stroke(0);
  line(left_border, top_border, right_border, top_border);
  line(right_border, top_border, right_border, bottom_border);
  line(right_border, bottom_border, left_border, bottom_border);
  line(left_border, bottom_border, left_border, top_border);
}




void border() {
  for (int i=0; i<numPoints; i++) {
    if (hull.points.get(i).x <= left_border + border_gap) {
      velocities.get(i).x *= -1;
      hull.points.get(i).x = left_border + border_gap;
    }
    if (hull.points.get(i).x >= right_border - border_gap) {
      velocities.get(i).x *= -1;
      hull.points.get(i).x = right_border - border_gap;
    }
    if (hull.points.get(i).y <= top_border + border_gap) {
      velocities.get(i).y *= -1;
      hull.points.get(i).y = top_border + border_gap;
    }
    if (hull.points.get(i).y >= bottom_border - border_gap) {
      velocities.get(i).y *= -1;
      hull.points.get(i).y = bottom_border - border_gap;
    }
  }
  for (int i=0; i<numDetectionPoints; i++) {
    if (detection_points.get(i).x <= left_border + border_gap) {
      detection_velocities.get(i).x *= -1;
      detection_points.get(i).x = left_border + border_gap;
    }
    if (detection_points.get(i).x >= right_border - border_gap) {
      detection_velocities.get(i).x *= -1;
      detection_points.get(i).x = right_border - border_gap;
    }
    if (detection_points.get(i).y <= top_border + border_gap) {
      detection_velocities.get(i).y *= -1;
      detection_points.get(i).y = top_border + border_gap;
    }
    if (detection_points.get(i).y >= bottom_border - border_gap) {
      detection_velocities.get(i).y *= -1;
      detection_points.get(i).y = bottom_border - border_gap;
    }
  }
}

void hull_gravity() {
  for (int i=0; i<numPoints; i++) {
    hull.points.get(i).add(velocities.get(i));
    velocities.get(i).add(new PVector(0, acceleration));
  }
}

void detection_gravity() {
  for (int i=0; i<numDetectionPoints; i++) {
    detection_points.get(i).add(detection_velocities.get(i));
    detection_velocities.get(i).add(new PVector(0, acceleration));
  }
}

void hull_random() {
  for (int i=0; i<hull.points.size(); i++) {
    hull.points.get(i).add(velocities.get(i));
    velocities.get(i).add(new PVector(random(-acceleration, acceleration), random(-acceleration, acceleration)));
  }
}

void detection_random() {
  for (int i=0; i<numDetectionPoints; i++) {
    detection_points.get(i).add(detection_velocities.get(i));
    detection_velocities.get(i).add(new PVector(random(-acceleration, acceleration), random(-acceleration, acceleration)));
  }
}
