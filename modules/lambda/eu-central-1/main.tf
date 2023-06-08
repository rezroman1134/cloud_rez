module "label" {
  source   = "cloudposse/label/null"
  version = "0.25.0"
  context   = var.context
  name      = var.name
}

module "label_courses" {
  source   = "cloudposse/label/null"
  version = "0.25.0"
  context   = var.context
  name      = var.name_courses
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.13.0"
  function_name = module.label.id
  description = "Get all authors"
  handler = "index.handler"
  runtime = "nodejs12.x"
  source_path = "${path.module}/lambda_src/get_all_authors/index.js"

      environment_variables = {
      TABLE_NAME = var.table_author_name
    }

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
  number_of_policies = 1

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:Scan"],
      resources = [var.table_author_arn]
    }
#    s3_read = {
#      effect    = "Deny",
#      actions   = ["s3:HeadObject", "s3:GetObject"],
#      resources = ["arn:aws:s3:::my-bucket/*"]
#    }
  }

    tags = module.label.tags
}

module "lambda_courses" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.13.0"
  function_name = module.label_courses.id
  description = "Get all courses"
  handler = "index.handler"
  runtime = "nodejs12.x"
  source_path = "${path.module}/lambda_src/get_all_courses/index.js"

      environment_variables = {
      TABLE_NAME = var.table_courses_name
    }

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"]
  number_of_policies = 1

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:Scan"],
      resources = [var.table_courses_arn]
    }
#    s3_read = {
#      effect    = "Deny",
#      actions   = ["s3:HeadObject", "s3:GetObject"],
#      resources = ["arn:aws:s3:::my-bucket/*"]
#    }
  }

    tags = module.label_courses.tags
}

module "label_get_course" {
  source   = "cloudposse/label/null"
  version  = "0.25.0"
  context  = var.context
  name     = var.name_get_course
}

module "label_save_course" {
  source   = "cloudposse/label/null"
  version  = "0.25.0"
  context  = var.context
  name     = var.name_save_course
}


module "label_update_course" {
  source   = "cloudposse/label/null"
  version  = "0.25.0"
  context  = var.context
  name     = var.name_update_course
}


module "label_delete_course" {
  source   = "cloudposse/label/null"
  version  = "0.25.0"
  context  = var.context
  name     = var.name_delete_course
}


module "lambda_get_course" {
    source      = "terraform-aws-modules/lambda/aws"
    version     = "4.13.0"
    function_name        = module.label_get_course.id 
    description = "Get course"
    handler     = "index.handler"
    runtime = "nodejs12.x"
    source_path = "${path.module}/lambda_src/get_course/index.js"
    environment_variables = {
      TABLE_NAME = var.table_courses_name  
    }

    create_role = false
    lambda_role = var.lambda_courses_role_arn 
    tags        = module.label_get_course.tags

}

module "lambda_save_course" {
    source      = "terraform-aws-modules/lambda/aws"
    version     = "4.13.0"
    function_name        = module.label_save_course.id    
    description = "Save course"
    handler     = "index.handler"
    runtime = "nodejs12.x"
    source_path = "${path.module}/lambda_src/save_course/index.js"
    environment_variables = {
      TABLE_NAME = var.table_courses_name  
    }

    create_role = false
    lambda_role = var.lambda_courses_role_arn 
    tags        = module.label_save_course.tags 

}

module "lambda_update_course" {
    source      = "terraform-aws-modules/lambda/aws"
    version     = "4.13.0"
    function_name        = module.label_update_course.id  
    description = "Update course"
    handler     = "index.handler"
    runtime = "nodejs12.x"
    source_path = "${path.module}/lambda_src/update_course/index.js"
    environment_variables = {
      TABLE_NAME = var.table_courses_name  
    }

    create_role = false
    lambda_role = var.lambda_courses_role_arn 
    tags        = module.label_update_course.tags

}

module "lambda_delete_course" {
    source      = "terraform-aws-modules/lambda/aws"
    version     = "4.13.0"
    function_name        = module.label_delete_course.id  
    description = "Delete course"
    handler     = "index.handler"
    runtime = "nodejs12.x"
    source_path = "${path.module}/lambda_src/delete_course/index.js"
    environment_variables = {
      TABLE_NAME = var.table_courses_name  
    }

    create_role = false
    lambda_role = var.lambda_courses_role_arn 
    tags        = module.label_delete_course.tags 

}