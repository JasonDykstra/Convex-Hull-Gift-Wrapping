class Convex_Hull {
  ArrayList<PVector> points = new ArrayList<PVector>();
  ArrayList<PVector> final_edge = new ArrayList<PVector>();

  PVector comparison_line = new PVector(0, 1);
  PVector test_line = new PVector(0, 0);

  float leftmost_distance;
  float angle;
  float record_angle = 360;

  int old_record_index;
  int new_record_index = 0;
  int leftmost_index = 0;

  boolean run = true;

  Convex_Hull(ArrayList<PVector> points) {
    this.points = points;

    leftmost_distance = height;
    for (PVector point : points) {
      if (point.x < leftmost_distance) {
        leftmost_distance = point.x;
        leftmost_index = points.indexOf(point);
      }
    }
    old_record_index = leftmost_index;
  }

  void run() {
    final_edge.clear();
    run=true;
    final_edge=calculate(points);
    display(final_edge);
  }

  ArrayList<PVector> calculate(ArrayList<PVector> input_points) {
    ArrayList<PVector> edge = new ArrayList<PVector>();
    while (run==true) {
      record_angle = 360;

      if (run == true) {
        for (int i=0; i<input_points.size(); i++) {
          if (i != old_record_index) {
            test_line.set(PVector.sub(input_points.get(i).copy(), input_points.get(old_record_index).copy()));        
            angle = PVector.angleBetween(comparison_line, test_line);
            if (abs(angle) < record_angle) {
              record_angle = abs(angle);
              new_record_index = i;
            }
          }
        }

        comparison_line.set(PVector.sub(input_points.get(new_record_index), input_points.get(old_record_index)));
        edge.add(input_points.get(new_record_index));
        old_record_index = new_record_index;
      }

      for (int i=0; i<edge.size(); i++) {
        for (int j=0; j<edge.size(); j++) {
          if (i!=j) {
            if (edge.get(i)==edge.get(j)) {
              run=false;
              edge.remove(edge.size()-1);
            }
          }
        }
      }
    }
    return edge;
  }

  void display(ArrayList<PVector> edge) {
    strokeWeight(3);
    rectMode(RADIUS);
    fill(255);
    for (PVector point : points) {
      stroke(0);
      rect(point.x, point.y, border_gap, border_gap);
    }
    stroke(255, 0, 0);
    for (int i=0; i<edge.size(); i++) {
      try {
        line(edge.get(i).x, edge.get(i).y, edge.get(i+1).x, edge.get(i+1).y);
      } 
      catch (IndexOutOfBoundsException e) {
        line(edge.get(i).x, edge.get(i).y, edge.get(0).x, edge.get(0).y);
      }
    }
  }

  boolean contains(PVector test_point) {
    ArrayList<PVector> test_points = new ArrayList<PVector>();
    ArrayList<PVector> test_edge = new ArrayList<PVector>();
    
    for (PVector point : points) {
      test_points.add(point);
    }
    test_points.add(test_point);
    Convex_Hull test_hull = new Convex_Hull(test_points);
    test_edge=test_hull.calculate(test_points);
    
    for(PVector vertex1 : test_edge){
      boolean match = false;
      for(PVector vertex2 : final_edge){
        if(vertex1==vertex2){
          match=true;
        }
      }
      if(match==false){
        return false;
      }
    }
    return true;
  }
  
  float getArea() {
    float area = 0;
    for (PVector p : points) {
      if (!final_edge.contains(p)) {
        for (int i = 0; i < final_edge.size(); i++) {
          PVector line1 = PVector.sub(new PVector(p.x, p.y), new PVector(final_edge.get(i).x, final_edge.get(i).y));
          PVector line2 = new PVector(0, 0);
          float angle = 0;
          try {
            line2 = PVector.sub(new PVector(p.x, p.y), new PVector(final_edge.get(i + 1).x, final_edge.get(i + 1).y));
          }
          catch (IndexOutOfBoundsException e) {
            line2 = PVector.sub(new PVector(p.x, p.y), new PVector(final_edge.get(0).x, final_edge.get(0).y));
          }
          angle = PVector.angleBetween(line1, line2);

          area += 0.5 * line1.mag() * line2.mag() * sin(angle);
        }
        break;
      }
    }
    return area;
  }
  
  float getPerimeter(){
    float perimeter = 0;
    for (PVector line : final_edge){
      perimeter+=line.mag();
    }
    return perimeter;
  }
}
