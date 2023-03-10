from diagrams import Diagram, Cluster

from diagrams.aws.network import Route53
from diagrams.aws.network import ELB
from diagrams.aws.database import RDSInstance

from diagrams.programming.language import Go, Python, TypeScript

with Diagram("Library Timeline",  filename="arch_diagram", outformat="jpg"):
    with Cluster("ECS"):
        api = Go("API")
        ml = Python("ML")
        ecs_group = [
            api,
            ml
        ]
    frontend = TypeScript("Front End") 
    route_53 = Route53("DNS")
    load_balancer = ELB("Load Balancer")
    database = RDSInstance("Database")
    frontend >> route_53 >> load_balancer >> api >> database
    database >> api >> ml >> api

